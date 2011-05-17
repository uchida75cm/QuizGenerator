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
package jp.progression.commands.display {
	import flash.display.DisplayObjectContainer;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.display.ChildIterator;
	import jp.nium.display.ExMovieClip;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.commands.lists.ParallelList;
	import jp.progression.events.ExecuteErrorEvent;
	import jp.progression.events.ExecuteEvent;
	
	/**
	 * <span lang="ja">RemoveAllChildren クラスは、対象の表示リストに登録されている全ての DisplayObject インスタンスを削除するコマンドクラスです。
	 * 削除するインスタンスが ICastObject インターフェイスを実装している場合には、CastEvent.CAST_REMOVED イベントが送出され、
	 * 対象のイベント処理の実行中に、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.commands.display.RemoveChild
	 * @see jp.progression.commands.display.RemoveChildAt
	 * @see jp.progression.commands.display.RemoveChildByName
	 * 
	 * @example <listing version="3.0">
	 * // CastSprite インスタンスを作成する
	 * var container:CastSprite = new CastSprite();
	 * var child1:CastSprite = new CastSprite();
	 * var child2:CastSprite = new CastSprite();
	 * var child3:CastSprite = new CastSprite();
	 * 
	 * // 親子関係を設定する
	 * container.addChild( child1 );
	 * container.addChild( child2 );
	 * container.addChild( child3 );
	 * 
	 * // RemoveAllChildren インスタンスを作成する
	 * var com:RemoveAllChildren = new RemoveAllChildren( container );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class RemoveAllChildren extends Command {
		
		/**
		 * <span lang="ja">全てのインスタンスを削除する対象の表示リストを含む DisplayObjectContainer インスタンスを取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get container():* { return _container; }
		public function set container( value:* ):void { _container = value; }
		private var _container:*;
		
		/**
		 * @private
		 */
		internal var _containerRef:DisplayObjectContainer;
		
		/**
		 * ParallelList インスタンスを取得します。
		 */
		private var _command:ParallelList;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい RemoveAllChildren インスタンスを作成します。</span>
		 * <span lang="en">Creates a new RemoveAllChildren object.</span>
		 * 
		 * @param containerRefOrId
		 * <span lang="ja">全ての DisplayObject インスタンスを削除する対象の DisplayObjectContainer インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function RemoveAllChildren( containerRefOrId:*, initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			
			// 引数を設定する
			_container = containerRefOrId;
			
			// 親クラスを初期化する
			super( _execute, _interrupt, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _execute():void {
			// 参照を取得する
			_containerRef = _getObjectRef( _container );
			
			// ParallelList を作成する
			_command = new ParallelList();

			// 全ての子を消去する
			var iterator:ChildIterator = new ChildIterator( _containerRef );
			while ( iterator.hasNext() ) {
				_command.addCommand( new RemoveChild( _containerRef, iterator.next(), this ) );
			}
			
			// コマンドを実行する
			_command.addEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
			_command.addEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
			_command.addEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
			_command.execute();
		}
		
		/**
		 * 中断実行されるコマンドの実装です。
		 */
		private function _interrupt():void {
			// すでに実行されていれば
			if ( _command ) {
				_command.interrupt();
			}
			
			// 破棄する
			_destroy();
		}
		
		/**
		 * @private
		 */
		internal function _getObjectRef( source:* ):DisplayObjectContainer {
			switch ( true ) {
				case source is DisplayObjectContainer	: { return DisplayObjectContainer( source ); }
				case source is String					: { return ExMovieClip.nium_internal::$collection.getInstanceById( source ) as DisplayObjectContainer; }
			}
			return null;
		}
		
		/**
		 * 破棄します。
		 */
		private function _destroy():void {
			// 破棄する
			_containerRef = null;
			
			if ( _command ) {
				// イベントリスナーを解除する
				_command.removeEventListener( ExecuteEvent.EXECUTE_COMPLETE, _executeComplete );
				_command.removeEventListener( ExecuteEvent.EXECUTE_INTERRUPT, _executeInterrupt );
				_command.removeEventListener( ExecuteErrorEvent.EXECUTE_ERROR, _error );
				
				// Command を破棄する
				_command = null;
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_container = null;
		}
		
		/**
		 * <span lang="ja">RemoveAllChildren インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an RemoveAllChildren subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい RemoveAllChildren インスタンスです。</span>
		 * <span lang="en">A new RemoveAllChildren object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new RemoveAllChildren( _container, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "container" );
		}
		
		
		
		
		
		/**
		 * コマンドの処理が完了した場合に送出されます。
		 */
		private function _executeComplete( e:ExecuteEvent ):void {
			// 破棄する
			_destroy();
			
			// 処理を終了する
			super.executeComplete();
		}
		
		/**
		 * コマンドの処理が中断された場合に送出されます。
		 */
		private function _executeInterrupt( e:ExecuteEvent ):void {
			// 中断する
			super.interrupt( e.enforcedInterrupting );
		}
		
		/**
		 * 処理の途中でエラーが発生した場合に送出されます。
		 */
		private function _error( e:ExecuteErrorEvent ):void {
			// 例外をスローする
			super.throwError( e.errorTarget as Command, e.errorObject );
		}
	}
}
