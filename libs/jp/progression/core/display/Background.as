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
package jp.progression.core.display {
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.display.ExMovieClip;
	import jp.nium.utils.StageUtil;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.core.PackageInfo;
	import jp.progression.events.ManagerEvent;
	import jp.progression.executors.ExecutorObject;
	import jp.progression.Progression;
	import jp.progression.ui.IContextMenuBuilder;
	
	/**
	 * @private
	 */
	public final class Background extends ExMovieClip implements IManageable {
		
		/**
		 * パッケージ内からの呼び出しかどうかを取得します。
		 */
		private static var _internallyCalled:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see jp.progression.events.ManagerEvent#MANAGER_ACTIVATE
		 * @see jp.progression.events.ManagerEvent#MANAGER_DEACTIVATE
		 */
		public function get manager():Progression { return _manager; }
		private var _manager:Progression;
		
		/**
		 * @private
		 */
		override public function get x():Number { return super.x; }
		override public function set x( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "x" ) ); }
		
		/**
		 * @private
		 */
		override public function get y():Number { return super.y; }
		override public function set y( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "y" ) ); }
		
		/**
		 * @private
		 */
		override public function get width():Number { return super.width; }
		override public function set width( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "width" ) ); }
		
		/**
		 * @private
		 */
		override public function get height():Number { return super.height; }
		override public function set height( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "height" ) ); }
		
		/**
		 * @private
		 */
		override public function get rotation():Number { return super.rotation; }
		override public function set rotation( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "rotation" ) ); }
		
		/**
		 * @private
		 */
		override public function get scaleX():Number { return super.scaleX; }
		override public function set scaleX( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "scaleX" ) ); }
		
		/**
		 * @private
		 */
		override public function get scaleY():Number { return super.scaleY; }
		override public function set scaleY( value:Number ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "scaleY" ) ); }
		
		/**
		 * @private
		 */
		override public function get mask():DisplayObject { return null; }
		override public function set mask( value:DisplayObject ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "mask" ) ); }
		
		/**
		 * @private
		 */
		override public function get scrollRect():Rectangle { return null; }
		override public function set scrollRect( value:Rectangle ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "scrollRect" ) ); }
		
		/**
		 * @private
		 */
		override public function get transform():Transform { return null; }
		override public function set transform( value:Transform ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "transform" ) ); }
		
		/**
		 * @private
		 */
		override public function get graphics():Graphics { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "graphics" ) ); }
		private function get _graphics():Graphics { return super.graphics; }
		
		/**
		 * @private
		 */
		public function get executor():ExecutorObject { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "executor" ) ); }
		
		/**
		 * IContextMenuBuilder インスタンスを取得します。
		 */
		private var _contextMenuBuilder:IContextMenuBuilder;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Background インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Background object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Background( initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( initObject );
			
			// パッケージ外から呼び出されたら例外をスローする
			if ( !_internallyCalled ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_008 ).toString( "Background" ) ); };
			
			// 初期化する
			_internallyCalled = false;
			
			// 初期化されていなければ終了する
			if ( !Progression.config ) {
				if ( PackageInfo.hasDebugger ) {
					Logger.warn( Logger.getLog( L10NProgressionMsg.getInstance().WARN_003 ).toString( this, "contextMenu" ) );
				}
				return;
			}
			
			// コンテクストメニューを作成する
			var cls:Class = Progression.config.contextMenuBuilder;
			if ( cls ) {
				_contextMenuBuilder = new cls( this );
			}
		}
		
		
		
		
		
		/**
		 * @private
		 */
		progression_internal static function $createInstance( manager:Progression ):Background {
			_internallyCalled = true;
			
			// SceneInfo を作成する
			var container:Background = new Background();
			container._manager = manager;
			
			// 矩形を描画する
			container._graphics.beginFill( 0x000000, 0 );
			container._graphics.drawRect( 0, 0, 100, 100 );
			container._graphics.endFill();
			
			// イベントリスナーを登録する
			container.addEventListener( Event.REMOVED_FROM_STAGE, container._removeFromStage, false, 0, true );
			manager.stage.addEventListener( Event.RESIZE, container._resize, false, 0, true );
			container._resize( null );
			
			// イベントを送出する
			container.dispatchEvent( new ManagerEvent( ManagerEvent.MANAGER_ACTIVATE, false, false, manager ) );
			
			return container;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">マネージャーオブジェクトとの関連付けを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">関連付けが成功したら true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #manager
		 * @see jp.progression.Progression
		 */
		public function updateManager():Boolean {
			return Boolean( !!_manager );
		}
		
		/**
		 * @private
		 */
		override public function addChild( child:DisplayObject ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addChild" ) );
		}
		
		/**
		 * @private
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addChildAt" ) );
		}
		
		/**
		 * @private
		 */
		override public function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "addChildAtAbove" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeChild" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeChildAt( index:int ):DisplayObject {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeChildAt" ) );
		}
		
		/**
		 * @private
		 */
		override public function removeAllChildren():void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "removeAllChildren" ) );
		}
		
		/**
		 * @private
		 */
		override public function setChildIndex( child:DisplayObject, index:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "setChildIndex" ) );
		}
		
		/**
		 * @private
		 */
		override public function setChildIndexAbove( child:DisplayObject, index:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "setChildIndexAbove" ) );
		}
		
		/**
		 * @private
		 */
		override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "swapChildren" ) );
		}
		
		/**
		 * @private
		 */
		override public function swapChildrenAt( index1:int, index2:int ):void {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_000 ).toString( "swapChildrenAt" ) );
		}
		
		
		
		
		
		/**
		* 
		 */
		private function _removeFromStage( e:Event ):void {
			// 画面に追加する
			_manager.stage.addChildAt( this, 0 );
			
			// 現在のノードおよび後続するノードで、イベントリスナーが処理されないようにする
			e.stopImmediatePropagation();
		}
		
		/**
		* 
		 */
		private function _resize( e:Event ):void {
			// 位置を調節する
			super.x = StageUtil.getMarginLeft( _manager.stage );
			super.y = StageUtil.getMarginTop( _manager.stage );
			
			// サイズを調節する
			super.width = _manager.stage.stageWidth;
			super.height = _manager.stage.stageHeight;
		}
	}
}
