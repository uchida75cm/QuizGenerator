/**
 * jp.nium Classes
 *
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 *
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.core.L10N {
	import jp.nium.core.debug.Log;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.I18N.Locale;
	
	/**
	 * @private
	 */
	public dynamic final class L10NNiumMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NNiumMsg = new L10NNiumMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const ERROR_000:String = "NiumError #000";
		public const ERROR_001:String = "NiumError #001";
		public const ERROR_002:String = "NiumError #002";
		public const ERROR_003:String = "NiumError #003";
		public const ERROR_004:String = "NiumError #004";
		public const ERROR_005:String = "NiumError #005";
		public const ERROR_006:String = "NiumError #006";
		public const ERROR_007:String = "NiumError #007";
		public const ERROR_008:String = "NiumError #008";
		public const ERROR_009:String = "NiumError #009";
		public const ERROR_010:String = "NiumError #010";
		public const ERROR_011:String = "NiumError #011";
		public const ERROR_012:String = "NiumError #012";
		public const ERROR_013:String = "NiumError #013";
		public const ERROR_014:String = "NiumError #014";
		public const ERROR_015:String = "NiumError #015";
		public const ERROR_016:String = "NiumError #016";
		public const ERROR_017:String = "NiumError #017";
		public const ERROR_018:String = "NiumError #018";
		public const ERROR_019:String = "NiumError #019";
		public const ERROR_020:String = "NiumError #020";
		public const ERROR_021:String = "NiumError #021";
		public const ERROR_022:String = "NiumError #022";
		public const ERROR_023:String = "NiumError #023";
		public const ERROR_024:String = "NiumError #024";
		public const ERROR_025:String = "NiumError #025";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NNiumMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": The method %0 is not implemented." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_000, ERROR_000 + ": メソッド %0 は実装されていません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": The property %0 is not implemented." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_001, ERROR_001 + ": プロパティ %0 は実装されていません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": Illegal write to read-only property %1 on %0." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_002, ERROR_002 + ": %0 の読み取り専用プロパティ %1 へは書き込みできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": Parameter %0 must be one of the accepted values." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_003, ERROR_003 + ": パラメータ %0 は承認された値の 1 つでなければなりません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": The supplied index is out of bounds." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_004, ERROR_004 + ": 指定したインデックスが境界外です。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": The format of the %0 is not correct." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_005, ERROR_005 + ": %0 の書式が正しくありません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": The object should inherit the class %0." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_006, ERROR_006 + ": 対象はクラス %0 を継承している必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_007, ERROR_007 + ": %0 はドキュメントクラス以外の用途で使用することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": Invalid %0." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_008, ERROR_008 + ": %0 が無効です。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_009, ERROR_009 + ": パラメータ %0 は null 以外でなければなりません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": %0 class cannot be instantiated." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_010, ERROR_010 + ": クラス %0 を直接インスタンス化することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_011, ERROR_011 + ": The supplied %0 must be a child of the caller." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_011, ERROR_011 + ": 指定した %0 は呼び出し元の子でなければなりません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_012, ERROR_012 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_012, ERROR_012 + ": 指定された範囲 %0 ～ %1 からは、有効な値を取得することができません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_013, ERROR_013 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_013, ERROR_013 + ": プロパティ %0 は読み取り専用です。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_014, ERROR_014 + ": Loaded file is an unknown type." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_014, ERROR_014 + ": 読み込まれたファイルの形式が不明です。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_015, ERROR_015 + ": The property name contains prohibited characters." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_015, ERROR_015 + ": プロパティ名に禁止文字が含まれています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_016, ERROR_016 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_016, ERROR_016 + ": %0 のフォーマットが正しくありません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_017, ERROR_017 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_017, ERROR_017 + ": %0 を使用するには %1 が実装されている必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_018, ERROR_018 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_018, ERROR_018 + ": 対象 %0 には、指定されたフレーム %1 が存在しません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_019, ERROR_019 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_019, ERROR_019 + ": 対象 %0 はダイナミッククラスである必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_020, ERROR_020 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_020, ERROR_020 + ": 対象はインターフェイス %0 を実装している必要があります。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_021, ERROR_021 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_021, ERROR_021 + ": インターフェイス IExDisplayObjectContainer を実装している対象 %0 に対して、Loader.content に格納されている表示オブジェクトを追加することはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_022, ERROR_022 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_022, ERROR_022 + ": 識別子 %0 は既に使用されています。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_023, ERROR_023 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_023, ERROR_023 + ": ドキュメントクラスが ExDocument クラスを継承していないため、プロパティ %0 の値を読み取ることができません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_024, ERROR_024 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_024, ERROR_024 + ": 初期化が完了していない対象 %0 に対して、この操作を行うことはできません。" ), Locale.JAPANESE );
			Logger.setLog( new Log( ERROR_025, ERROR_025 + ": ENGLISH MESSAGE IS NOT REGISTERED." ), Locale.ENGLISH );
			Logger.setLog( new Log( ERROR_025, ERROR_025 + ": 機能 %0 を使用するには %1 以降の環境で実行する必要があります。" ), Locale.JAPANESE );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NNiumMsg {
			return _instance;
		}
	}
}
