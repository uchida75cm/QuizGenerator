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
package jp.progression.core.L10N {
	import jp.nium.core.debug.Log;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.I18N.Locale;
	import jp.nium.core.L10N.L10NMsg;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * @private
	 */
	public dynamic final class L10NExecuteMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NExecuteMsg = new L10NExecuteMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const ERROR_000:String = "ExecuteError #000";
		public const ERROR_001:String = "ExecuteError #001";
		public const ERROR_002:String = "ExecuteError #002";
		public const ERROR_003:String = "ExecuteError #003";
		public const ERROR_004:String = "ExecuteError #004";
		public const ERROR_005:String = "ExecuteError #005";
		public const ERROR_006:String = "ExecuteError #006";
		public const ERROR_007:String = "ExecuteError #007";
		public const ERROR_008:String = "ExecuteError #008";
		public const ERROR_009:String = "ExecuteError #009";
		public const ERROR_010:String = "ExecuteError #010";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NExecuteMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": 実行中ではない対象 %0 に対して操作を行うことはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": メソッド %0 を実行するには %1 が実装されている必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": すでに実行中の %0 を再度実行することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": 実行されていない %0 を中断、または終了させることはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": 中断処理中の %0 を再度中断することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": 実行されていない %0 に対してエラーを通知することはできません。\n通知されたエラー: %1" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": %0 の処理がタイムアウトしました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": %0 の読み込みが正常に完了できませんでした。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": 再開可能な処理は存在しません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": メソッド %0 は、Progression の管理するフローに関連付けられたイベント発生時以外では実行できません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": 実行中の %0 を破棄することはできません。" ), Locale.JAPANESE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NExecuteMsg {
			return _instance;
		}
	}
}
