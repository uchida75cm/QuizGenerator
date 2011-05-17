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
package jp.progression.config {
	import jp.nium.core.debug.Logger;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.managers.HistoryManager;
	import jp.progression.core.proto.Configuration;
	import jp.progression.executors.CommandExecutor;
	import jp.progression.ui.ContextMenuBuilder;
	import jp.progression.ui.ToolTip;
	
	/**
	 * <span lang="ja">BasicAppConfig クラスは、Progression の非同期処理をコマンドを使用して動作させるための環境設定クラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.ActivatedLicenseType
	 * @see jp.progression.Progression#initialize()
	 * 
	 * @example <listing version="3.0">
	 * // BasicAppConfig を作成する
	 * var config:BasicAppConfig = new BasicAppConfig();
	 * 
	 * // Progression を初期化する
	 * Progression.initialize( config );
	 * 
	 * // Progression インスタンスを作成する
	 * var manager:Progression = new Progression( "index", stage );
	 * </listing>
	 */
	public final class BasicAppConfig extends Configuration {
		
		/**
		 * <span lang="ja">新しい BasicAppConfig インスタンスを作成します。</span>
		 * <span lang="en">Creates a new BasicAppConfig object.</span>
		 * 
		 * @param activatedLicenseType
		 * <span lang="ja">適用させたいライセンスの種類です。</span>
		 * <span lang="en"></span>
		 * @param executor
		 * <span lang="ja">汎用的な処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 * @param toolTipRenderer
		 * <span lang="ja">ツールチップ処理の実装として使用したいクラスです。</span>
		 * <span lang="en"></span>
		 */
		public function BasicAppConfig( activatedLicenseType:String = null, executor:Class = null, toolTipRenderer:Class = null ) {
			// 親クラスを初期化する
			super( activatedLicenseType, null, null, HistoryManager, executor || CommandExecutor, null, ContextMenuBuilder, toolTipRenderer || ToolTip, null );
			
			// ライセンスを制限する
			switch( super.activatedLicenseType ) {
				case "GPL"				:
				case "PLL Basic"		:
				case "PLL Web"			:
				case "PLL Application"	: { break; }
				default					: { throw new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_017 ).toString( super.className, super.activatedLicenseType ) ); }
			}
		}
	}
}
