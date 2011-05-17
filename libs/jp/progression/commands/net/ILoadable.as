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
package jp.progression.commands.net {
	import flash.events.IEventDispatcher;
	
	/**
	 * <span lang="ja">ILoadable インターフェイスは、対象のコマンドに読み込み処理操作を実装します。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public interface ILoadable extends IEventDispatcher {
		
		/**
		 * <span lang="ja">読み込み操作によって受信したデータです。</span>
		 * <span lang="en">The data received from the load operation.</span>
		 */
		function get data():*;
		function set data( value:* ):void;
		
		/**
		 * <span lang="ja">現在の読み込み対象を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get target():ILoadable;
		
		/**
		 * <span lang="ja">percent プロパティの算出時の自身の重要性を取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		function get factor():Number;
		function set factor( value:Number ):void;
		
		/**
		 * <span lang="ja">loaded プロパティと total プロパティから算出される読み込み状態をパーセントで取得します。</span>
		 * <span lang="en"></span>
		 */
		function get percent():Number;
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの内、すでに読み込み処理が完了した数を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get loaded():uint;
		
		/**
		 * <span lang="ja">登録されている ILoadable を実装したインスタンスの総数を取得します。</span>
		 * <span lang="en"></span>
		 */
		function get total():uint;
		
		/**
		 * <span lang="ja">対象の読み込み済みのバイト数です。</span>
		 * <span lang="en">The number of bytes that are loaded for the target.</span>
		 */
		function get bytesLoaded():uint;
		
		/**
		 * <span lang="ja">全体の圧縮後のバイト数です。</span>
		 * <span lang="en">The number of compressed bytes in the entire target.</span>
		 */
		function get bytesTotal():uint;
	}
}
