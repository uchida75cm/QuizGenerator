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
package jp.progression.commands {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ClassUtil;
	
	/**
	 * <span lang="ja">CommandInterruptType クラスは、Command クラスの interrupt() メソッドを実行した際の中断方法を示す値を提供します。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.commands.Command#interruptType
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public final class CommandInterruptType {
		
		/**
		 * <span lang="ja">コマンド中断時、処理が実行される以前の状態に戻すように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const RESTORE:int = 0;
		
		/**
		 * <span lang="ja">コマンド中断時、その時点の状態で停止するように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const ABORT:int = 1;
		
		/**
		 * <span lang="ja">コマンド中断時、処理が完了された状態と同様になるように指定します。</span>
		 * <span lang="en"></span>
		 */
		public static const SKIP:int = 2;
		
		
		
		
		
		/**
		 * @private
		 */
		public function CommandInterruptType() {
			throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( ClassUtil.getClassName( this ) ) );
		}
	}
}
