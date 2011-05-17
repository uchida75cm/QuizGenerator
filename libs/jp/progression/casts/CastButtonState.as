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
package jp.progression.casts {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">CastButtonState クラスは、CastButton クラスの状態に対応した値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.casts.CastButton#state
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class CastButtonState {
		
		/**
		 * <span lang="ja">ボタンが無効化されている状態であることを指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const DISABLE:int = 0;
		
		/**
		 * <span lang="ja">現在のシーン位置がボタンに設定されているシーンの子以下に位置していることを指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const CHILD:int = 1;
		
		/**
		 * <span lang="ja">現在のシーン位置がボタンに設定されているシーンと同じであることを指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const CURRENT:int = 2;
		
		/**
		 * <span lang="ja">現在のシーン位置がボタンに設定されているシーンの親以上に位置していることを指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const PARENT:int = 3;
		
		/**
		 * <span lang="ja">ボタンが通常状態であることを指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const NEUTRAL:int = 4;
		
		
		
		
		
		/**
		 * @private
		 */
		public function CastButtonState() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
