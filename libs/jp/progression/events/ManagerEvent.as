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
	
	/**
	 * <span lang="ja">IManageable インターフェイスを実装したオブジェクトが Progression インスタンスと関連付けられた場合などに ManagerEvent オブジェクトが送出されます。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // ManagerEvent インスタンスを作成する
	 * var event:ManagerEvent = new ManagerEvent();
	 * </listing>
	 */
	public class ManagerEvent extends Event {
		
		/**
		 * <span lang="ja">managerReady イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ManagerEvent.MANAGER_READY constant defines the value of the type property of an managerReady event object.</span>
		 * 
		 * @see jp.progression.Progression#event:managerReady
		 */
		public static const MANAGER_READY:String = "managerReady";
		
		/**
		 * <span lang="ja">managerLockChange イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ManagerEvent.MANAGER_LOCK_CHANGE constant defines the value of the type property of an managerLockChange event object.</span>
		 * 
		 * @see jp.progression.Progression#event:managerLockChange
		 */
		public static const MANAGER_LOCK_CHANGE:String = "managerLockChange";
		
		/**
		 * <span lang="ja">managerActivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ManagerEvent.MANAGER_ACTIVATE constant defines the value of the type property of an managerActivate event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:managerActivate
		 * @see jp.progression.casts.CastButton#event:managerActivate
		 * @see jp.progression.casts.CastDocument#event:managerActivate
		 * @see jp.progression.casts.CastImageLoader#event:managerActivate
		 * @see jp.progression.casts.CastLoader#event:managerActivate
		 * @see jp.progression.casts.CastMovieClip#event:managerActivate
		 * @see jp.progression.casts.CastObject#event:managerActivate
		 * @see jp.progression.casts.CastSprite#event:managerActivate
		 * @see jp.progression.casts.CastTextField#event:managerActivate
		 * @see jp.progression.scenes.SceneObject#event:managerActivate
		 */
		public static const MANAGER_ACTIVATE:String = "managerActivate";
		
		/**
		 * <span lang="ja">managerDeactivate イベントオブジェクトの type プロパティ値を定義します。</span>
		 * <span lang="en">The ManagerEvent.MANAGER_DEACTIVATE constant defines the value of the type property of an managerDeactivate event object.</span>
		 * 
		 * @see jp.progression.casts.CastBitmap#event:managerDeactivate
		 * @see jp.progression.casts.CastButton#event:managerDeactivate
		 * @see jp.progression.casts.CastDocument#event:managerDeactivate
		 * @see jp.progression.casts.CastImageLoader#event:managerDeactivate
		 * @see jp.progression.casts.CastLoader#event:managerDeactivate
		 * @see jp.progression.casts.CastMovieClip#event:managerDeactivate
		 * @see jp.progression.casts.CastObject#event:managerDeactivate
		 * @see jp.progression.casts.CastSprite#event:managerDeactivate
		 * @see jp.progression.casts.CastTextField#event:managerDeactivate
		 * @see jp.progression.scenes.SceneObject#event:managerDeactivate
		 */
		public static const MANAGER_DEACTIVATE:String = "managerDeactivate";
		
		
		
		
		
		/**
		 * <span lang="ja">実行対象となるオブジェクトを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get managerTarget():Object { return _managerTarget; }
		private var _managerTarget:Object;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ManagerEvent インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ManagerEvent object.</span>
		 * 
		 * @param type
		 * <span lang="en">ManagerEvent.type としてアクセス可能なイベントタイプです。</span>
		 * <span lang="en">The type of the event, accessible as ManagerEvent.type.</span>
		 * @param bubbles
		 * <span lang="en">ManagerEvent インスタンスがイベントフローのバブリング段階で処理されるかどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ManagerEvent object participates in the bubbling stage of the event flow. The default value is false.</span>
		 * @param cancelable
		 * <span lang="en">ManagerEvent インスタンスがキャンセル可能かどうかを判断します。デフォルト値は false です。</span>
		 * <span lang="en">Determines whether the ManagerEvent object can be canceled. The default values is false.</span>
		 * @param managerTarget
		 * <span lang="ja">実行対象となるオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ManagerEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false, managerTarget:Object = null ) {
			// 親クラスを初期化する
			super( type, bubbles, cancelable );
			
			// 引数を設定する
			_managerTarget = managerTarget;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">ManagerEvent インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an ManagerEvent subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい ManagerEvent インスタンスです。</span>
		 * <span lang="en">A new ManagerEvent object that is identical to the original.</span>
		 */
		override public function clone():Event {
			return new ManagerEvent( super.type, super.bubbles, super.cancelable, _managerTarget );
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
			return super.formatToString( "ManagerEvent", "type", "bubbles", "cancelable" );
		}
	}
}
