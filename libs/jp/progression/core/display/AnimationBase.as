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
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.progression.casts.CastMovieClip;
	import jp.progression.core.components.animation.IAnimationComp;
	
	/**
	 * <span lang="ja">AnimationBase クラスは、アニメーションコンポーネントとして動作させるために必要な機能を実装した表示オブジェクトクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class AnimationBase extends CastMovieClip {
		
		/**
		 * <span lang="ja">コンポーネントの実装として使用される場合の対象コンポーネントを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get component():IAnimationComp { return _component; }
		private var _component:IAnimationComp;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい AnimationBase インスタンスを作成します。</span>
		 * <span lang="en">Creates a new AnimationBase object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function AnimationBase( initObject:Object = null ) {
			// 引数を設定する
			_component = initObject as IAnimationComp;
			
			// 親クラスを初期化する
			super( initObject );
			
			// 継承せずにインスタンスを生成しようとしたら例外をスローする
			if ( Object( this ).constructor == AnimationBase ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
		}
	}
}
