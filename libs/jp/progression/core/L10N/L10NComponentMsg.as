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
	public dynamic final class L10NComponentMsg extends L10NMsg {

		/**
		 * @private
		 */
		private static const _instance:L10NComponentMsg = new L10NComponentMsg();





		/**
		 * @private
		 */
		public const WARN_000:String = "ComponentWarn #000";
		public const WARN_001:String = "ComponentWarn #001";
		public const WARN_002:String = "ComponentWarn #002";
		public const WARN_003:String = "ComponentWarn #003";
		public const WARN_004:String = "ComponentWarn #004";
		public const WARN_005:String = "ComponentWarn #005";
		public const WARN_006:String = "ComponentWarn #006";
		public const WARN_007:String = "ComponentWarn #007";
		public const WARN_008:String = "ComponentWarn #008";
		public const WARN_009:String = "ComponentWarn #009";
		public const WARN_010:String = "ComponentWarn #010";
		public const ERROR_000:String = "ComponentError #000";





		/**
		 * @private
		 */
		public function L10NComponentMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }

			Logger.setLog( new Log( WARN_000, WARN_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_000, WARN_000 + ": 対象 %0 には複数のボタンが設定されているため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": 対象 %0 にボタンコンポーネントがネスト状態で設定されているため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": 対象 %0 は、ルート直下に設置されていないため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": ローダーコンポーネントが対象 %0 の 1 フレーム目に設置されていないため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_004, WARN_004 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_004, WARN_004 + ": 対象 %0 にはすでにローダーコンポーネントが設置されているため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_005, WARN_005 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_005, WARN_005 + ": " ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_006, WARN_006 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_006, WARN_006 + ": ローダーコンポーネントを使用する場合には、ドキュメントクラスに任意のクラスを使用することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_007, WARN_007 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_007, WARN_007 + ": 対象 %0 は、アニメーションコンポーネント以外のコンポーネントと併用されているため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_008, WARN_008 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_008, WARN_008 + ": 対象 %0 は、エフェクトコンポーネント以外のコンポーネントと併用されているため、%1 コンポーネントは無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_009, WARN_009 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_009, WARN_009 + ": 現在設定されている環境設定 %0 では、同期機能は使用はできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_010, WARN_010 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_010, WARN_010 + ": コンポーネント %0 のバージョンと、Progression ライブラリのバージョンが異なるため、コンポーネントが正しく動作しない可能性があります。" ), Locale.JAPANESE );

			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": PRML 定義ファイル %0 の読み込みに失敗しました。" ), Locale.JAPANESE );
		}





		/**
		 * @private
		 */
		public static function getInstance():L10NComponentMsg {
			return _instance;
		}
	}
}
