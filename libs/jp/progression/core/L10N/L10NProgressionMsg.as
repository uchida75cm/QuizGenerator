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
	public dynamic final class L10NProgressionMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NProgressionMsg = new L10NProgressionMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const INFO_000:String = "ProgressionInfo #000";
		public const INFO_001:String = "ProgressionInfo #001";
		public const INFO_002:String = "ProgressionInfo #002";
		public const INFO_003:String = "ProgressionInfo #003";
		public const INFO_004:String = "ProgressionInfo #004";
		public const INFO_005:String = "ProgressionInfo #005";
		public const INFO_006:String = "ProgressionInfo #006";
		public const INFO_007:String = "ProgressionInfo #007";
		public const INFO_008:String = "ProgressionInfo #008";
		public const WARN_000:String = "ProgressionWarn #000";
		public const WARN_001:String = "ProgressionWarn #001";
		public const WARN_002:String = "ProgressionWarn #002";
		public const WARN_003:String = "ProgressionWarn #003";
		public const ERROR_000:String = "ProgressionError #000";
		public const ERROR_001:String = "ProgressionError #001";
		public const ERROR_002:String = "ProgressionError #002";
		public const ERROR_003:String = "ProgressionError #003";
		public const ERROR_004:String = "ProgressionError #004";
		public const ERROR_005:String = "ProgressionError #005";
		public const ERROR_006:String = "ProgressionError #006";
		public const ERROR_007:String = "ProgressionError #007";
		public const ERROR_008:String = "ProgressionError #008";
		public const ERROR_009:String = "ProgressionError #009";
		public const ERROR_010:String = "ProgressionError #010";
		public const ERROR_011:String = "ProgressionError #011";
		public const ERROR_012:String = "ProgressionError #012";
		public const ERROR_013:String = "ProgressionError #013";
		public const ERROR_014:String = "ProgressionError #014";
		public const ERROR_015:String = "ProgressionError #015";
		public const ERROR_016:String = "ProgressionError #016";
		public const ERROR_017:String = "ProgressionError #017";
		public const ERROR_018:String = "ProgressionError #018";
		public const ERROR_019:String = "ProgressionError #019";
		public const ERROR_020:String = "ProgressionError #020";
		public const ERROR_021:String = "ProgressionError #021";
		public const ERROR_022:String = "ProgressionError #022";
		public const ERROR_023:String = "ProgressionError #023";
		public const ERROR_024:String = "ProgressionError #024";
		public const ERROR_025:String = "ProgressionError #025";
		public const ERROR_026:String = "ProgressionError #026";
		public const ERROR_027:String = "ProgressionError #027";
		public const ERROR_028:String = "ProgressionError #028";
		public const ERROR_029:String = "ProgressionError #029";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NProgressionMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Logger.setLog( new Log( INFO_000, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_000, "拡張ライブラリ %0 が有効化されました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_001, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_001, "Flash IDE 上で設置済みの表示オブジェクトを CastPreloader の管理する background に移動しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_002, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_002, "同期対象の HTML データを読み込みました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_003, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_003, "解析モジュール %0 を検出しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_004, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_004, "解析モジュール %0 に対してログ %1 を送信しました。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_005, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_005, "一定時間アイドル状態が続いたため、先読み処理を開始します。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_006, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_006, "先読み対象 %0 を読み込みます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_007, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_007, "先読み処理を完了しました。\n" ), Locale.JAPANESE );
			Logger.setLog( new Log( INFO_008, "ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( INFO_008, "先読み処理を中断します。\n" ), Locale.JAPANESE );
			
			Logger.setLog( new Log( WARN_000, WARN_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_000, WARN_000 + ": ブラウザ以外で実行されたため、SWF ファイルと同階層に存在する同名の HTML ファイルを自動的に読み込みます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_001, WARN_001 + ": 同期対象となる HTML データが発見できませんでした。" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_002, WARN_002 + ": 同期対象の HTML データは XHTML 形式でなければいけません。\n通知されたエラー: %0" ), Locale.JAPANESE );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( WARN_003, WARN_003 + ": 環境設定が初期化される前に実装が要求されたため、対象 %0 のプロパティ %1 は正しく実装されません。" ), Locale.JAPANESE );
			
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": 環境設定 %0 は AIR ランタイム上では初期化できません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": 環境設定 %0 は AIR ランタイム以外では初期化できません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": 対象 %0 は、すでに初期化されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": 現在の環境設定では、有効なシンクロナイザが指定されていません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": 対象の %0 プロパティは読み取り専用に設定されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": 指定された %0 識別子 %1 はすでに登録されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": プロパティ %0 に一度設定した値を上書きすることはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": Progression 識別子を省略することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": すでに初期化済みであるため、環境設定 %0 として初期化できません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": 対象シーン %0 が十分に読み込まれていないため、移動処理を続行することができません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": 対象シーン %0 が存在しません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_011, ERROR_011 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_011, ERROR_011 + ": 指定されたクラス %0 はコンパイルに含まれていません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_012, ERROR_012 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_012, ERROR_012 + ": プロパティ %0 に指定されているクラス %1 はクラス %2 を継承している必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_013, ERROR_013 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_013, ERROR_013 + ": 移動先として設定されている %0　は、有効な移動先ではありません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_014, ERROR_014 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_014, ERROR_014 + ": 環境設定が初期化されていない状態で Progression インスタンスを作成することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_015, ERROR_015 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_015, ERROR_015 + ": 対象 %0 に表示オブジェクトを関連付けるには foreground, container, background プロパティのいずれかを経由する必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_016, ERROR_016 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_016, ERROR_016 + ": SceneLoader で読み込む SWF ファイルは、CastDocument クラスを継承している、またはローダーコンポーネントを実装している必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_017, ERROR_017 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_017, ERROR_017 + ": 環境設定 %0 に対してライセンス種別 %1 を適用することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_018, ERROR_018 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_018, ERROR_018 + ": 指定されたクラス %0 はコンパイルに含まれないため無効化されます。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_019, ERROR_019 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_019, ERROR_019 + ": 移動先に NaS を指定することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_020, ERROR_020 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_020, ERROR_020 + ": 対象 %0 の同期機能はすでに有効化されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_021, ERROR_021 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_021, ERROR_021 + ": SceneLoader 経由で読み込まれる対象 %0 の CastDocument クラスのコンストラクタで Progression 識別子を省略することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_022, ERROR_022 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_022, ERROR_022 + ": 対象の CastPreloader は準備が完了していないか、すでにコンテンツが読み込まれています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_023, ERROR_023 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_023, ERROR_023 + ": プロパティ %0 を使用するには CastPreloader 経由で読み込まれている必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_024, ERROR_024 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_024, ERROR_024 + ": シーンリストに追加されていない SceneLoader インスタンスの load() メソッドを実行する場合、loaderContainer プロパティを省略することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_025, ERROR_025 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_025, ERROR_025 + ": 対象 %0 はすでに破棄されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_026, ERROR_026 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_026, ERROR_026 + ": カレントシーン及びカレントシーンを含むルート上に存在するシーンに対して、フローに影響のある操作を行うことはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_027, ERROR_027 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_027, ERROR_027 + ": Progression クラスのコンストラクタ第二引数 container は Stage または Sprite クラスである必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_028, ERROR_028 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_028, ERROR_028 + ": Progression クラスのコンストラクタ第二引数に指定される container は stage 以下の表示リストに追加されている必要があります。" ), Locale.JAPANESE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NProgressionMsg {
			return _instance;
		}
	}
}
