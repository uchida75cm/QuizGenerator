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
package jp.progression.events {
	import flash.events.Event;
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">対象の SceneObject オブジェクトがシーンイベントフロー上で処理ポイントに位置した場合や、状態が変化した場合に SceneEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @author seyself http://blog.seyself.com/
	 * 
	 * @example <listing version="3.0">
	 * // SceneEvent インスタンスを作成する
	 * var event:SceneEvent = new SceneEvent();
	 * </listing>
	 */
	public class SceneEvent extends Event {
		
		/**
		 * <span lang="ja">sceneLoad イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_LOAD constant defines the value of the type property of an sceneLoad event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneLoad
		 */
		public static const SCENE_LOAD:String = "sceneLoad";
		
		/**
		 * <span lang="ja">sceneUnload イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_UNLOAD constant defines the value of the type property of an sceneUnload event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneUnload
		 */
		public static const SCENE_UNLOAD:String = "sceneUnload";
		
		/**
		 * <span lang="ja">sceneInit イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_INIT constant defines the value of the type property of an sceneInit event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneInit
		 */
		public static const SCENE_INIT:String = "sceneInit";
		
		/**
		 * <span lang="ja">sceneInitComplete イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_INIT_COMPLETE constant defines the value of the type property of an sceneInitComplete event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneInitComplete
		 */
		public static const SCENE_INIT_COMPLETE:String = "sceneInitComplete";
		
		/**
		 * <span lang="ja">sceneGoto イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_GOTO constant defines the value of the type property of an sceneGoto event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneGoto
		 */
		public static const SCENE_GOTO:String = "sceneGoto";
		
		/**
		 * <span lang="ja">sceneDescend イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_DESCEND constant defines the value of the type property of an sceneDescend event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneDescend
		 */
		public static const SCENE_DESCEND:String = "sceneDescend";
		
		/**
		 * <span lang="ja">sceneAscend イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_ASCEND constant defines the value of the type property of an sceneAscend event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneAscend
		 */
		public static const SCENE_ASCEND:String = "sceneAscend";
		
		/**
		 * <span lang="ja">scenePreLoad イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_PRE_LOAD constant defines the value of the type property of an scenePreLoad event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneLoader#event:scenePreLoad
		 */
		public static const SCENE_PRE_LOAD:String = "scenePreLoad";
		
		/**
		 * <span lang="ja">scenePostUnload イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_POST_UNLOAD constant defines the value of the type property of an scenePostUnload event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneLoader#event:scenePostUnload
		 */
		public static const SCENE_POST_UNLOAD:String = "scenePostUnload";
		
		/**
		 * <span lang="ja">sceneAdded イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_ADDED constant defines the value of the type property of an sceneAdded event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneAdded
		 */
		public static const SCENE_ADDED:String = "sceneAdded";
		
		/**
		 * <span lang="ja">sceneAddedToRoot イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_ADDED_TO_ROOT constant defines the value of the type property of an sceneAddedToRoot event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneAddedToRoot
		 */
		public static const SCENE_ADDED_TO_ROOT:String = "sceneAddedToRoot";
		
		/**
		 * <span lang="ja">sceneRemoved イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_REMOVED constant defines the value of the type property of an sceneRemoved event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneRemoved
		 */
		public static const SCENE_REMOVED:String = "sceneRemoved";
		
		/**
		 * <span lang="ja">sceneRemovedFromRoot イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_REMOVED_FROM_ROOT constant defines the value of the type property of an sceneRemovedFromRoot event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneRemovedFromRoot
		 */
		public static const SCENE_REMOVED_FROM_ROOT:String = "sceneRemovedFromRoot";
		
		/**
		 * <span lang="ja">sceneTitleChange イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_TITLE_CHANGE constant defines the value of the type property of an sceneTitleChange event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneObject#event:sceneTitleChange
		 */
		public static const SCENE_TITLE_CHANGE:String = "sceneTitleChange";
		
		/**
		 * <span lang="ja">sceneQueryChange イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The SceneEvent.SCENE_QUERY_CHANGE constant defines the value of the type property of an sceneQueryChange event object.</span>
		 * 
		 * @see jp.progression.scenes.SceneInfo#event:sceneQueryChange
		 */
		public static const SCENE_QUERY_CHANGE:String = "sceneQueryChange";
		
		
		
		
		
		/**
		 * <span lang="ja">イベント発生時のカレントイベントタイプを取得します。</span>
		 * <span lang="en">The object that is actively processing the Event object with an event listener.</span>
		 */
		public function get targetEventType():String { return _targetEventType; }
		private var _targetEventType:String;
		
		/**
		 * <span lang="ja">イベントターゲットです。</span>
		 * <span lang="en">The event target.</span>
		 */
		override public function get target():Object { return super.target && progression_internal::$target || super.target; }
		
		/**
		 * @private
		 */
		progression_internal var $target:Object;
		
		/**
		 * <span lang="ja">イベントリスナーで Event オブジェクトをアクティブに処理しているオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		override public function get currentTarget():Object { return super.currentTarget && progression_internal::$currentTarget || super.currentTarget; }
		
		/**
		 * @private
		 */
		progression_internal var $currentTarget:Object;
		
		/**
		 * <span lang="ja">イベントフローの現在の段階です。</span>
		 * <span lang="en">The current phase in the event flow.</span>
		 */
		override public function get eventPhase():uint  { return progression_internal::$eventPhase || super.eventPhase; }
		
		/**
		 * @private
		 */
		progression_internal var $eventPhase:uint = 0;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SceneEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SceneEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">SceneEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as SceneEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">SceneEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the SceneEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">SceneEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the SceneEvent object can be canceled. The default values is false.</span>
		 * @param targetEventType
		 * <span lang="ja">イベント発生時のカレントイベントタイプです。</span>
		 * <span lang="en"></span>
		 */
		public function SceneEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, targetEventType:String = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_targetEventType = targetEventType;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">SceneEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an SceneEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい SceneEvent インスタンスです。</span>
		 * <span lang="en">A new SceneEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new SceneEvent( super.type, super.bubbles, super.cancelable, _targetEventType );
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
			return super.formatToString( "SceneEvent", "type", "bubbles", "cancelable", "eventPhase", "target", "currentTarget", "targetEventType" );
		}
	}
}
