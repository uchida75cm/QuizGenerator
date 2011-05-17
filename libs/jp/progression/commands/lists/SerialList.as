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
	import jp.progression.commands.Func;
	import jp.progression.commands.Trace;
	import jp.progression.commands.Wait;
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
	 * <span lang="ja">SerialList クラスは、登録された複数のコマンドを 1 つづつ順番に実行させるためのコマンドリストクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // SerialList インスタンスを作成する
	 * var list:SerialList = new SerialList();
	 * 
	 * // コマンドを登録する
	 * list.addCommand(
	 * 	// 順番に実行されるため、結果的に 6 秒待つ
	 * 	new Wait( 1 ),
	 * 	new Wait( 2 ),
	 * 	new Wait( 3 )
	 * );
	 * 
	 * // コマンドを実行する
	 * list.execute();
	 * </listing>
	 */
	public class SerialList extends CommandList {
		
		/**
		 * 現在処理中の Command インスタンスを取得します。 
		 */
		private var _current:Command;
		
		/**
		 * 処理が実行中かどうかを取得します。
		 */
		private var _running:Boolean = false;
		
		/**
		 * 強制的な中断処理であるかどうかを取得します。
		 */
		private var _enforced:Boolean = false;
		
		/**
		 * <span lang="ja">コマンドオブジェクトが ExecuteEvent.EXECUTE_POSITION イベントを受け取った場合に呼び出されるイベントハンドラメソッドを取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #scope
		 * @see jp.progression.events.ExecuteEvent#EXECUTE_POSITION
		 */
		public function get onPosition():Function { return _onPosition; }
		public function set onPosition( value:Function ):void { _onPosition = value; }
		private var _onPosition:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SerialList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SerialList object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンス、関数、数値、配列などを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function SerialList( initObject:Object = null, ... commands:Array ) {
			// 親クラスを初期化する
			super( executeFunction, interruptFunction, initObject );
			
			// initObject が SerialList であれば
			var com:SerialList = initObject as SerialList;
			if ( com ) {
				// 特定のプロパティを継承する
				_onPosition = com._onPosition;
			}
			
			// initObject に自身のサブクラス以外のコマンドが指定されたら警告する
			var com2:Command = initObject as Command;
			if ( com2 && !( com2 is SerialList ) && PackageInfo.hasDebugger ) {
				Logger.warn( Logger.getLog( L10NCommandMsg.getInstance().WARN_000 ).toString( super.className, com2.className ) );
			}
			
			// コマンドリストに登録する
			super.addCommand.apply( null, _convert( this, commands ) );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		internal static function _convert( target:Command, commands:Array ):Array {
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var value:* = commands[i];
				
				// 型に応じて変換する
				switch ( true ) {
					// Command インスタンス、または null であれば次へ
					case value == undefined	:
					case value == null		:
					case value is Command	: { break; }
					
					// 関数であれば Func コマンドに変換する
					case value is Function	: { commands[i] = new Func( value as Function ); break; }
					
					// 数値であればディレイ付き Command コマンドに変換する
					case value is Number	: { commands[i] = new Wait( value ); break; }
					
					// 配列であればシンタックスシュガーとして処理する
					case value is Array		: {
						var list:CommandList;
						
						switch ( true ) {
							case target is SerialList		: { list = new ParallelList(); break; }
							case target is ParallelList		:
							default							: { list = new SerialList(); }
						}
						
						list.addCommand.apply( null, value as Array );
						commands[i] = list;
						break;
					}
					
					// それ以外は全て Trace コマンドに変換する
					default					: { commands[i] = new Trace( "trace:", value ); }
				}
			}
			
			return commands;
		}
		
		/**
		 * @private
		 */
		protected function executeFunction():void {
			// 実行中でなければ初期化する
			if ( !_running ) {
				super.reset();
			}
			
			// 状態を再設定する
			_running = true;
			
			// 次のコマンドが存在すれば
			if ( super.hasNextCommand() ) {
				// 現在の対象コマンドを取得する
				_current = super.nextCommand();
				
				// イベントリスナーを登録する
				_current.addEventListener( ExecuteEvent.EXECUTE_POSITION, dispatchEvent );
				_current.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_current.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_current.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// イベントを送出する
				super.dispatchEvent( new ExecuteEvent( ExecuteEvent.EXECUTE_POSITION, false, false, _current ) );
				
				// イベントハンドラメソッドを実行する
				if ( _onPosition != null ) {
					_onPosition.apply( scope || this );
				}
				
				// 処理を実行する
				_current.execute( extra );
			}
			else {
				// 実行を停止する
				_running = false;
				
				// 処理を終了する
				super.executeComplete();
			}
		}
		
		/**
		 * @private
		 */
		protected function interruptFunction():void {
			// 実行中であれば
			if ( _current && _current.state > 0 ) {
				// 現在の対象を保存する
				var current:Command = _current;
				
				// 破棄する
				_destroy();
				
				// 中断処理を実行する
				current.interrupt();
			}
			
			// 状態を変更する
			_enforced = false;
			_running = false;
		}
		
		/**
		 * <span lang="ja">コマンド処理を中断します。
		 * このメソッドを実行するためには、事前に execute() メソッドが実行されている必要があります。</span>
		 * <span lang="en"></span>
		 * 
		 * @param enforced
		 * <span lang="ja">親が存在する場合に、親の処理も中断させたい場合には true を、自身のみ中断したい場合には false を指定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #state
		 * @see #scope
		 * @see #execute()
		 */
		override public function interrupt( enforced:Boolean = false ):void {
			// 強制的に中断するかどうかを保存する
			_enforced = enforced;
			
			// 親のメソッドを実行する
			super.interrupt( enforced );
		}
		
		/**
		 * <span lang="ja">登録されているコマンドの最後尾に新しくコマンドを追加します。
		 * 関数を指定した場合には、自動的に Func コマンドに変換され、
		 * 数値を指定した場合には、自動的に Wait コマンドに変換され、
		 * 配列を指定した場合には、自動的に ParallelList コマンドに変換され、
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
		 * // SerialList インスタンスを作成する
		 * var com:SerialList = new SerialList();
		 * 
		 * // コマンドを登録する
		 * com.addCommand(
		 * 	// この関数は Func コマンドに変換される
		 * 	function():void {
		 * 		trace( "Func コマンドを実行" );
		 * 	},
		 * 	// この配列は ParallelList に変換され、結果 3 秒遅延する
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
		override public function addCommand( ...commands:Array ):void {
			// 親のメソッドを実行する
			super.addCommand.apply( null, _convert( this, commands ) );
		}
		
		/**
		 * <span lang="ja">現在実行中のコマンドの次の位置に新しくコマンドを追加します。
		 * 関数を指定した場合には、自動的に Func コマンドに変換され、
		 * 数値を指定した場合には、自動的に Wait コマンドに変換され、
		 * 配列を指定した場合には、自動的に ParallelList コマンドに変換され、
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
		override public function insertCommand( ...commands:Array ):void {
			// 親のメソッドを実行する
			super.insertCommand.apply( null, _convert( this, commands ) );
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			if ( _current ) {
				// イベントリスナーを解除する
				_current.removeEventListener( ExecuteEvent.EXECUTE_POSITION, dispatchEvent );
				_current.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_current.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_current.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// 破棄する
				_current = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_onPosition = null;
		}
		
		/**
		 * <span lang="ja">SerialList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an SerialList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい SerialList インスタンスです。</span>
		 * <span lang="en">A new SerialList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new SerialList( this );
		}
		
		
		
		
		
		/**
		 * コマンドの処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
			
			if ( super.state == 2 ) {
				// 処理を実行する
				executeFunction();
			}
		}
		
		/**
		 * コマンドの処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			if ( e.enforcedInterrupting ) {
				// 中断処理を実行する
				interrupt( e.enforcedInterrupting );
			}
			else {
				// 処理を完了する
				_executeComplete( null );
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
