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
package jp.progression.ui {
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import jp.progression.core.impls.IDisposable;
	
	/**
	 * <span lang="ja">IToolTip インターフェイスは、対象にツールチップ機能を実装します。</span>
	 * <span lang="en"></span>
	 */
	public interface IToolTip extends IDisposable {
		
		/**
		 * <span lang="ja">関連付けられている Sprite インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():Sprite;
		
		/**
		 * <span lang="ja">ツールチップに表示するテキストを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get text():String;
		function set text( value:String ):void;
		
		/**
		 * <span lang="ja">ツールチップのテキスト色を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get textColor():uint;
		function set textColor( value:uint ):void;
		
		/**
		 * <span lang="ja">ツールチップに適用したい TextFormat を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get textFormat():TextFormat;
		function set textFormat( value:TextFormat ):void;
		
		/**
		 * <span lang="ja">ツールチップの背景色を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get backgroundColor():uint;
		function set backgroundColor( value:uint ):void;
		
		/**
		 * <span lang="ja">ツールチップのボーダー色を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get borderColor():uint;
		function set borderColor( value:uint ):void;
	}
}
