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
package jp.progression.core.impls {
	import jp.progression.scenes.SceneId;
	
	/**
	 * @private
	 */
	public interface ICastButton extends ICastObject {
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先を示すシーン識別子を取得または設定します。
		 * sceneId プロパティと href プロパティが両方とも設定されている場合には、href プロパティの設定が優先されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #href
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		function get sceneId():SceneId;
		function set sceneId( value:SceneId ):void;
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先の URL を取得または設定します。
		 * sceneId プロパティと href プロパティが両方とも設定されている場合には、href プロパティの設定が優先されます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		function get href():String;
		function set href( value:String ):void;
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先を開くウィンドウ名を取得または設定します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #navigateTo()
		 * @see jp.progression.casts.CastButtonWindowTarget
		 */
		function get windowTarget():String;
		function set windowTarget( value:String ):void;
		
		/**
		 * <span lang="ja">ボタンの機能をキーボードから使用するためのアクセスキーを取得または設定します。
		 * 設定できるキーはアルファベットの A ～ Z までの値です。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #windowTarget
		 * @see #navigateTo()
		 */
		function get accessKey():String;
		function set accessKey( value:String ):void;
		
		/**
		 * <span lang="ja">マウス状態に応じて Executor を使用した処理を行うかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get mouseEventEnabled():Boolean;
		function set mouseEventEnabled( value:Boolean ):void;
		
		/**
		 * <span lang="ja">CastButton インスタンスにポインティングデバイスが合わされているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get isRollOver():Boolean;
		
		/**
		 * <span lang="ja">CastButton インスタンスでポインティングデバイスのボタンを押されているかどうかを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get isMouseDown():Boolean;
		
		/**
		 * <span lang="ja">ボタンの状態を取得します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see jp.progression.casts.CastButtonState
		 */
		
		function get state():int;
		
		/**
		 * <span lang="ja">指定されたシーン識別子、または URL の示す先に移動します。
		 * 引数が省略された場合には、あらかじめ CastButton インスタンスに指定されている sceneId プロパティ、 href プロパティが示す先に移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param location
		 * <span lang="ja">移動先を示すシーン識別子、または URL です。</span>
		 * <span lang="en"></span>
		 * @param window
		 * <span lang="en">location パラメータで指定されたドキュメントを表示するブラウザウィンドウまたは HTML フレームです。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #sceneId
		 * @see #href
		 * @see #windowTarget
		 */
		function navigateTo( location:*, window:String = null ):void;
	}
}
