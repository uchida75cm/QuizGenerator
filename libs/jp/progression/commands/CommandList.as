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
package jp.progression.commands {
	import jp.nium.collections.UniqueList;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.impls.IDisposable;
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">CommandList クラスは、コマンドリストでコマンドコンテナとして機能する全てのコマンドの基本となるクラスです。</span>
	 * <span lang="en"></span>
	 */
	public class CommandList extends Command {
		
		/**
		 * インスタンスの数を取得します。
		 */
		private static var _parentNum:Number = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">子コマンドインスタンスが保存されている配列です。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 * <span lang="en"></span>
		 */
		public function get commands():Array { return _commands ? _commands.toArray() : []; }
		private function get _commands():UniqueList { return __commands ||= new UniqueList(); }
		private var __commands:UniqueList;
		
		/**
		 * <span lang="ja">子として登録されているコマンド数を取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get numCommands():int { return _commands ? _commands.numItems : 0; }
		
		/**
		 * <span lang="ja">現在処理しているコマンド位置を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get position():int { return _position; }
		private var _position:int = 0;
		
		/**
		 * 実行処理関数を取得します。
		 */
		private var _parentId:Number;
		
		/**
		 * 実行処理関数を取得します。
		 */
		private var _executeFunction:Function;
		
		/**
		 * 中断処理関数を取得します。
		 */
		private var _interruptFunction:Function;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい CommandList インスタンスを作成します。</span>
		 * <span lang="en">Creates a new CommandList object.</span>
		 * 
		 * @param executeFunction
		 * <span lang="ja">実行関数です。</span>
		 * <span lang="en"></span>
		 * @param interruptFunction
		 * <span lang="ja">中断関数です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンスを含む配列です。</span>
		 * <span lang="en"></span>
		 */
		public function CommandList( executeFunction:Function = null, interruptFunction:Function = null, initObject:Object = null, ... commands:Array ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_executeFunction = executeFunction;
			_interruptFunction = interruptFunction;
			
			// 親クラスを初期化する
			super( executeFunction, interruptFunction, initObject );
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == CommandList ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			// 親番号を設定する
			_parentId = _parentNum++;
			
			// initObject が CommandList であれば
			var com:CommandList = initObject as CommandList;
			if ( com ) {
				// 特定のプロパティを継承する
				var source:UniqueList = com._commands;
				for ( var i:int = 0, l:int = source.numItems; i < l; i++ ) {
					_addCommandAt( source.getItemAt( i ).clone(), numCommands );
				}
			}
			
			// コマンドリストに登録する
			_addCommand.apply( null, commands );
		}
		
		
		
		
		
		/**
		 * <span lang="ja">登録されているコマンドリストの最後尾に新しくコマンドインスタンスを追加します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンスを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #insertCommand()
		 * @see #clearCommand()
		 */
		public function addCommand( ... commands:Array ):void {
			_addCommand.apply( null, commands );
		}
		
		/**
		 * 登録されているコマンドリストの最後尾に新しくコマンドインスタンスを追加します。
		 */
		private function _addCommand( ... commands:Array ):void {
			// コマンドリストに登録する
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:Command = commands[i] as Command;
				if ( command ) {
					_addCommandAt( command, numCommands );
				}
			}
			
			// 子が存在すれば親リストに登録する
			if ( _commands.numItems > 0 ) {
				Command.progression_internal::$parentCommands[this] = _parentId;
			}
		}
		
		/**
		 * <span lang="ja">現在実行中のコマンドインスタンスの次の位置に新しくコマンドインスタンスを追加します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param commands
		 * <span lang="ja">登録したいコマンドインスタンスを含む配列です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #addCommand()
		 * @see #clearCommand()
		 */
		public function insertCommand( ... commands:Array ):void {
			// コマンドリストに登録する
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:Command = commands[i] as Command;
				if ( command ) {
					_addCommandAt( command, _position + i );
				}
			}
			
			// 子が存在すれば親リストに登録する
			if ( _commands.numItems > 0 ) {
				Command.progression_internal::$parentCommands[this] = _parentId;
			}
		}
		
		/**
		 * コマンドリストに対して子コマンドを追加します。
		 */
		private function _addCommandAt( command:Command, index:int ):Command {
			// インデックスの範囲を超えていれば例外をスローする
			if ( index < 0 || numCommands < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// すでに親が存在していれば解除する
			var parent:CommandList = command.parent;
			if ( parent ) {
				parent._removeCommandAt( parent._commands.getItemIndex( command ) );
				index = Math.min( index, parent.numCommands );
			}
			
			// 登録する
			_commands.addItemAt( command, index );
			command.progression_internal::$parentId = _parentId;
			
			return command;
		}
		
		/**
		 * <span lang="ja">コマンドインスタンスをリストから削除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param completely
		 * <span lang="en">true が設定されている場合は登録されている全ての登録を解除し、false の場合には現在処理中のコマンドインスタンス以降の登録を解除します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #addCommand()
		 * @see #insertCommand()
		 */
		public function clearCommand( completely:Boolean = false ):void {
			// 現在のリストをコピーする
			var commands:Array = _commands.toArray();
			
			// 全て、もしくは現在の処理位置以降を削除する
			commands = completely ? commands : commands.splice( _position );
			
			// 親子関係を再設定する
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var command:Command = Command( commands[i] );
				var list:CommandList = command as CommandList;
				
				if ( list ) {
					list.clearCommand( completely );
				}
				
				_removeCommandAt( _commands.getItemIndex( command ) );
			}
			
			// 登録情報が存在しなければ
			if ( _commands.numItems < 1 ) {
				__commands.dispose();
				__commands = null;
				
				// 親リストから破棄する
				delete Command.progression_internal::$parentCommands[this];
			}
			
			// 現在の処理位置を再設定する
			_position = Math.min( _position, numCommands );
		}
		
		/**
		 * コマンドリストから子コマンドを削除します。
		 */
		private function _removeCommandAt( index:int ):Command {
			// 登録されていなければ例外をスローする
			if ( index < 0 || numCommands < index ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// コマンドを取得する
			var command:Command = _commands.getItemAt( index );
			
			// 登録を解除する
			_commands.removeItemAt( index );
			command.progression_internal::$parentId = -1;
			
			return command;
		}
		
		/**
		 * <span lang="ja">指定のインデックス位置にある子 Command インスタンスオブジェクトを返します。</span>
		 * <span lang="en">Returns the child Command instance that exists at the specified index.</span>
		 * 
		 * @param index
		 * <span lang="ja">子 Command インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the command object.</span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子 Command インスタンスです。</span>
		 * <span lang="en">The child Command at the specified index position.</span>
		 */
		public function getCommandAt( index:int ):Command {
			return _commands.getItemAt( index );
		}
		
		/**
		 * <span lang="ja">指定された名前に一致する子 Command インスタンスを返します。</span>
		 * <span lang="en">Returns the child Command that exists with the specified name.</span>
		 * 
		 * @param name
		 * <span lang="ja">返される子 Command インスタンスの名前です。</span>
		 * <span lang="en">The name of the command to return.</span>
		 * @return
		 * <span lang="ja">指定された名前を持つ子 Command インスタンスです。</span>
		 * <span lang="en">The child Command with the specified name.</span>
		 */
		public function getCommandIndex( command:Command ):int {
			return _commands.getItemIndex( command );
		}
		
		/**
		 * <span lang="ja">次のコマンドインスタンスを取得して、処理位置を次に進めます。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">次に位置するコマンドインスタンスです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #hasNextCommand()
		 * @see #reset()
		 */
		protected function nextCommand():Command {
			return _commands.getItemAt( _position++ );
		}
		
		/**
		 * <span lang="ja">次のコマンドインスタンスが存在するかどうかを返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">次のコマンドインスタンスが存在すれば true を、それ以外の場合には false です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #nextCommand()
		 * @see #reset()
		 */
		protected function hasNextCommand():Boolean {
			return Boolean( _position < numCommands );
		}
		
		/**
		 * <span lang="ja">コマンドの処理位置を最初に戻します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #position
		 * @see #nextCommand()
		 * @see #hasNextCommand()
		 */
		protected function reset():void {
			_position = 0;
		}
		
		/**
		 * <span lang="ja">コマンド処理中に例外が発生したことを通知します。
		 * エラー処理が発生すると、コマンド処理が停止します。
		 * 問題を解決し、通常フローに戻す場合には executeComplete() メソッドを、問題が解決されず中断処理を行いたい場合には interrupt() メソッドを実行してください。
		 * 関数内で問題が解決、または中断処理に移行しなかった場合には ExecuteEvent.ERROR イベントが送出されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @param target
		 * <span lang="ja">問題の発生元である Command インスタンスです。</span>
		 * <span lang="en"></span>
		 * @param error
		 * <span lang="ja">原因となるエラーオブジェクトです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #catchError
		 */
		override protected function throwError( target:Command, error:Error ):void {
			// メッセージを追記する
			var messages:Array = error.message.split( "\n" );
			messages.splice( 1, 0, "\t   on " + _position + "/" + numCommands + " positions of the " + toString() );
			error.message = messages.join( "\n" );
			
			// 親のメソッドを実行する
			super.throwError( target, error );
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			var commands:Array = _commands.toArray();
			
			clearCommand( true );
			
			for ( var i:int = 0, l:int = commands.length; i < l; i++ ) {
				var disposable:IDisposable = commands[i] as IDisposable;
				
				if ( disposable ) {
					disposable.dispose();
				}
			}
			
			_executeFunction = null;
			_interruptFunction = null;
		}
		
		/**
		 * <span lang="ja">CommandList インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an CommandList subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい CommandList インスタンスです。</span>
		 * <span lang="en">A new CommandList object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new CommandList( _executeFunction, _interruptFunction, this );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null );
		}
	}
}
