/**
 * Progression 4
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://progression.jp/
 * 
 * Progression Libraries is dual licensed under the "Progression Library License" and "GPL".
 * http://progression.jp/license
 */
package jp.progression.commands.lists {
	import jp.nium.core.debug.Logger;
	import jp.progression.commands.Command;
	import jp.progression.commands.CommandList;
	import jp.progression.core.L10N.L10NCommandMsg;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">リストに登録されているコマンドの実行処理位置が変更された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_POSITION
	 */
	[Event( name="executePosition", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">コマンド処理中に状態が更新された場合に送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @eventType jp.progression.events.ExecuteEvent.EXECUTE_UPDATE
	 */
	[Event( name="executeUpdate", type="jp.progression.events.ExecuteEvent" )]
	
	/**
	 * <span lang="ja">ParallelList クラスは、指定された複数のコマンドを全て同時に実行させるためのコマンドリストクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ParallelList インスタンスを作成する
	 * var list:ParallelList = new ParallelList();
	 * 
	 * // コマンドを登録する
	 * list.addCommand(
	 * 	// 全て同時に実行されるため、結果的に 3 秒待つ
	 * 	new Wait( 1 ),
	 * 	new Wait( 2 ),
	 * 	new Wait( 3 )
	 * );
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class ParallelList extends CommandList {
		
		/**
		 * <span lang="ja">現在の処理位置を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get count():int { return _count; }
		private var _count:int = 0;
		
		/**
		 * <span lang="ja">現在の処理中のコマンド数を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get total():int {
			if ( _commands.length == 0 ) { return super.numCommands; }
			return _total;
		}
		private var _total:int = 0;
		
		/**
		 * 現在処理中の Command インスタンスを保存した配列を取得します。 
		 */
		private var _commands:Array;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ExecuteEvent.EXECUTE_UPDATE イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see jp.progression.events.ExecuteEvent#EXECUTE_UPDATE
		 */
		public function get onUpdate():Function { return _onUpdate; }
		public function set onUpdate( value:Function ):void { _onUpdate = value; }
		private var _onUpdate:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ParallelList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ParallelList object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンス、関数、数値、配列などを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function ParallelList( initObject:Object = null, ... commands:Array ) {
			// 初期化する
			_commands = [];
			
			// 親クラスを初期化する
			super( executeFunction, interruptFunction, initObject );
			
			// initObject が ParallelList であれば
			var com:ParallelList = initObject as ParallelList;
			if ( com ) {
				// 特定のプロパティを継承する
				_onUpdate = com._onUpdate;
			}
			
			// initObject に自身のサブクラス以外のコマンドが指定されたら警告する
			var com2:Command = initObject as Command;
			if ( com2 && !( com2 is ParallelList ) && PackageInfo.hasDebugger ) {
				Logger.warn( Logger.getLog( L10NCommandMsg.getInstance().WARN_000 ).toString( super.className, com2.className ) );
			}
			
			// コマンドリストに登録する
			addCommand.apply( null, commands );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		protected function executeFunction():void {
			// 初期化する
			super.reset();
			_commands = [];
			_count = 0;
			_total = 0;
			
			// 現在登録されている全てのコマンドを取得する
			while ( super.hasNextCommand() ) {
				var com:Command = super.nextCommand();
				
				// イベントリスナーを登録する
				com.addEventListener( ExecuteEvent.EXECUTE_POSITION, dispatchEvent );
				com.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				com.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				com.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// 登録する
				_commands.push( com );
			}
			
			// 最大値を取得する
			_total = _commands.length;
			
			// 登録されていなければ
			if ( _total < 1 ) {
				// 処理を終了する
				super.executeComplete();
				return;
			}
			
			// コマンドを同時に実行する
			var commands:Array = _commands.slice();
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				com = commands[i];
				
				// イベントを送出する
				super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_POSITION, false, false, com ) );
				
				// 実行中であれば実行する
				if ( super.state == 2 ) {
					com.execute( extra );
				}
			}
		}
		
		/**
		 * @private
		 */
		protected function interruptFunction():void {
			// コマンドを同時に中断する
			var commands:Array = _commands.slice();
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var com:Command = commands[i];
				
				// イベントリスナーを解除する
				com.removeEventListener( ExecuteEvent.EXECUTE_POSITION, dispatchEvent );
				com.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				com.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				com.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// 実行中であれば中断する
				if ( com.state > 0 ) {
					com.interrupt();
				}
			}
			
			// 初期化する
			_commands = [];
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy( command:Command ):void {
			if ( command ) {
				// イベントリスナーを解除する
				command.removeEventListener( ExecuteEvent.EXECUTE_POSITION, dispatchEvent );
				command.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				command.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				command.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// 登録から削除する
				for ( var i:int = 0, l:int = _commands.length; i < l; i++ ) {
					if ( _commands[i] != command ) { continue; }
					
					_commands.splice( i, 1 );
					break;
				}
			}
		}
		
		/**
		 * <span lang="ja">登録されているコマンドの最後尾に新しくコマンドを追加します。
		 * 関数を指定した場合には、自動的に Func コマンドに変換され、
		 * 数値を指定した場合には、自動的に Wait コマンドに変換され、
		 * 配列を指定した場合には、自動的に SerialList コマンドに変換され、
		 * それ以外の値は、全て自動的に Trace コマンドに変換されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #insertCommand()
		 * @see #clearCommand()
		 * 
		 * @example <listing version="3.0">
		 * // ParallelList インスタンスを作成する
		 * var com:ParallelList = new ParallelList();
		 * 
		 * // コマンドを登録する
		 * com.addCommand(
		 * 	// この関数は Func コマンドに変換される
		 * 	function():void {
		 * 		trace( "Func コマンドを実行" );
		 * 	},
		 * 	// この配列は SerialList に変換され、結果 6 秒遅延する
		 * 	[
		 * 		// この数値はそれぞれ 1 ～ 3 秒待つ Wait コマンドに変換される
		 * 		1,
		 * 		2,
		 * 		3
		 * 	],
		 * 	// この String は Trace コマンドに変換される
		 * 	"complete"
		 * );
		 * 
		 * // コマンドを実行する
		 * com.execute();
		 * </listing>
		 */
		override public function addCommand( ... commands:Array ):void {
			// 親のメソッドを実行する
			super.addCommand.apply( null, SerialList._convert( this, commands ) );
		}
		
		/**
		 * <span lang="ja">現在実行中のコマンドの次の位置に新しくコマンドを追加します。
		 * 関数を指定した場合には、自動的に Func コマンドに変換され、
		 * 数値を指定した場合には、自動的に Wait コマンドに変換され、
		 * 配列を指定した場合には、自動的に SerialList コマンドに変換され、
		 * それ以外の値は、全て自動的に Trace コマンドに変換されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドを含む配列です。</span>
		 * <span lang="en"></span>
		 * @return
		 * <span lang="ja">自身の参照です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #addCommand()
		 * @see #clearCommand()
		 */
		override public function insertCommand( ... commands:Array ):void {
			// 親のメソッドを実行する
			super.insertCommand.apply( null, SerialList._convert( this, commands ) );
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_onUpdate = null;
		}
		
		/**
		 * <span lang="ja">ParallelList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ParallelList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ParallelList インスタンスです。</span>
		 * <span lang="en">A new ParallelList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new ParallelList( this );
		}
		
		
		
		
		
		/**
		 * コマンドの処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// 破棄する
			_destroy( Command( e.target ) );
			
			// カウントをアップする
			_count++;
			
			// イベントを送出する
			super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_UPDATE, false, false, e.target ) );
			
			// イベントハンドラメソッドを実行する
			if ( _onUpdate != null ) {
				_onUpdate.apply( scope || this );
			}
			
			// まだ存在すれば終了する
			if ( _commands.length > 0 ) { return; }
			
			// 実行中であれば終了する
			if ( super.state > 0 ) {
				super.executeComplete();
			}
		}
		
		/**
		 * コマンドの処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			if ( e.enforcedInterrupting ) {
				// 処理を中断する
				super.interrupt( e.enforcedInterrupting );
			}
			else {
				// 処理を完了する
				super.executeComplete();
			}
		}
		
		/**
		 * 処理の途中でエラーが発生した場合に送出されます。
		 */
		private function _error( e:ExecuteErrorEvent ):void {
			// エラー処理を実行する
			super.throwError( e.errorTarget as Command, e.errorObject );
		}
	}
}
