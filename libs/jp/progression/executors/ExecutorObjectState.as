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
package jp.progression.executors {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">ExecutorObjectState クラスは、ExecutorObject クラスの実行状態を示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.Progression#state
	 * @see jp.progression.executors.ExecutorObject#state
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class ExecutorObjectState {
		
		/**
		 * <span lang="ja">コマンドが実行されていない状態となるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const IDLING:int = 0;
		
		/**
		 * <span lang="ja">コマンドが遅延処理中となるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const DELAYING:int = 1;
		
		/**
		 * <span lang="ja">コマンドが実行されている状態となるように指定します。></span>
		 * <span lang="en"></span>
		 */
		public static const EXECUTING:int = 2;
		
		/**
		 * <span lang="ja">コマンドが中断処理中となるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const INTERRUPTING:int = 3;
		
		
		
		
		
		/**
		 * @private
		 */
		public function ExecutorObjectState() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
