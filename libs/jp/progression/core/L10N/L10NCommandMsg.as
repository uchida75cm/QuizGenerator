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
	public dynamic final class L10NCommandMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NCommandMsg = new L10NCommandMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const WARN_000:String = "CommandWarn #000";
		public const WARN_001:String = "CommandWarn #001";
		public const ERROR_000:String = "CommandError #000";
		public const ERROR_001:String = "CommandError #001";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NCommandMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Logger.setLog( new Log( WARN_000, WARN_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_000, WARN_000 + ": コマンドリスト %0 の initObject に登録されたコマンド %1 は実行されません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": コマンド %0 のプロパティ %1 が必要とする時間値の単位がミリ秒で指定されている可能性があります。" ), Locale.JAPANESE );
			
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": コマンド Stop の親は IRepeatable インターフェイスを実装している必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": コマンド DoTweener が Tweener に渡すパラメータに対してイベントハンドラメソッドを指定することはできません。" ), Locale.JAPANESE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NCommandMsg {
			return _instance;
		}
	}
}
