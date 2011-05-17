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
	public dynamic final class L10NDebugMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NDebugMsg = new L10NDebugMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const INFO_000:String = "DebugInfo #000";
		public const INFO_001:String = "DebugInfo #001";
		public const INFO_002:String = "DebugInfo #002";
		public const INFO_003:String = "DebugInfo #003";
		public const INFO_004:String = "DebugInfo #004";
		public const INFO_005:String = "DebugInfo #005";
		public const INFO_006:String = "DebugInfo #006";
		public const INFO_007:String = "DebugInfo #007";
		public const INFO_008:String = "DebugInfo #008";
		public const INFO_009:String = "DebugInfo #009";
		public const INFO_010:String = "DebugInfo #010";
		public const INFO_011:String = "DebugInfo #011";
		public const INFO_012:String = "DebugInfo #012";
		public const INFO_013:String = "DebugInfo #013";
		public const INFO_014:String = "DebugInfo #014";
		public const INFO_015:String = "DebugInfo #015";
		public const INFO_016:String = "DebugInfo #016";
		public const INFO_017:String = "DebugInfo #011";
		public const INFO_018:String = "DebugInfo #018";
		public const INFO_019:String = "DebugInfo #019";
		public const INFO_020:String = "DebugInfo #020";
		public const INFO_021:String = "DebugInfo #021";
		public const INFO_022:String = "DebugInfo #022";
		public const INFO_023:String = "DebugInfo #023";
		public const INFO_024:String = "DebugInfo #024";
		public const INFO_025:String = "DebugInfo #025";
		public const INFO_026:String = "DebugInfo #026";
		public const INFO_027:String = "DebugInfo #027";
		public const INFO_028:String = "DebugInfo #028";
		public const INFO_029:String = "DebugInfo #029";
		public const INFO_030:String = "DebugInfo #030";
		public const INFO_031:String = "DebugInfo #031";
		public const INFO_032:String = "DebugInfo #032";
		public const INFO_033:String = "DebugInfo #033";
		public const INFO_034:String = "DebugInfo #034";
		public const INFO_035:String = "DebugInfo #035";
		public const INFO_036:String = "DebugInfo #036";
		public const WARN_000:String = "DebugWarn #000";
		public const WARN_001:String = "DebugWarn #001";
		public const WARN_002:String = "DebugWarn #002";
		public const WARN_003:String = "DebugWarn #003";
		public const ERROR_000:String = "DebugError #000";
		public const ERROR_001:String = "DebugError #001";
		public const ERROR_002:String = "DebugError #002";
		public const ERROR_003:String = "DebugError #003";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NDebugMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Logger.setLog( new Log( INFO_000, "It failed in debugging connection." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_000, "デバッグ接続に失敗しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_001, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_001, "対象 %0 の監視には対応していなません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_002, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_002, "対象 %0 は、すでに監視対象に設定されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_003, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_003, "シーン移動を開始, 目的地 = %0" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_004, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_004, "シーン %0 に移動" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_005, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_005, "シーン %0 でイベント %1 を実行" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_006, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_006, "移動先を変更, 目的地 = %0" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_007, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_007, "シーン移動を完了" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_008, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_008, "シーン %0 の lock プロパティが %1 に変更されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_009, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_009, "シーン %0 のタイトルが %1 に変更されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_010, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_010, "非同期処理を開始, 実行者 = %0, 対象 = %1, 種別 = %2" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_011, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_011, "非同期処理を完了" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_012, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_012, "%0 がマネージャーオブジェクト %1 と関連付けられました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_013, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_013, "%0 とマネージャーオブジェクトの関連付けが解除されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_014, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_014, "%0 コマンドを実行" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_015, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_015, "%0 コマンドを完了" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_016, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_016, "同期処理を開始, 実行者 = %0, 対象 = %1, 種別 = %2" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_017, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_017, "同期処理を完了" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_018, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_018, "%0 をシーンリストに追加しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_019, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_019, "%0 に子シーン %1 を追加しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_020, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_020, "%0 をシーンリストから削除しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_021, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_021, "%0 から子シーン %1 を削除しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_022, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_022, "%0 を表示リストに追加しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_023, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_023, "%0 に子ディスプレイ %1 を追加しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_024, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_024, "%0 を表示リストから削除しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_025, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_025, "%0 から子ディスプレイ %1 を削除しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_026, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_026, "%0 の準備が完了しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_027, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_027, "%0 のデータが更新されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_028, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_028, "%0 に関連付けられているクエリ値が %1 に更新されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_029, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_029, "ボタン %0 でマウスダウンしました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_030, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_030, "ボタン %0 でマウスダウンを完了しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_031, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_031, "ボタン %0 でマウスアップしました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_032, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_032, "ボタン %0 でマウスアップを完了しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_033, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_033, "ボタン %0 でロールオーバーしました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_034, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_034, "ボタン %0 でロールオーバーを完了しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_035, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_035, "ボタン %0 でロールアウトしました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_036, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_036, "ボタン %0 でロールアウトを完了しました。" ), Locale.JAPANESE );
			
			Logger.setLog( new Log( WARN_000, WARN_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_000, WARN_000 + ": 非同期処理を中断" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": %0 コマンドを中断" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": シーン移動を中断" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": 同期処理を中断" ), Locale.JAPANESE );
			
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": 非同期処理中に例外発生" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": %0 コマンドの実行中に例外発生" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": シーン移動中に例外発生" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": 同期処理中に例外発生" ), Locale.JAPANESE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NDebugMsg {
			return _instance;
		}
	}
}
