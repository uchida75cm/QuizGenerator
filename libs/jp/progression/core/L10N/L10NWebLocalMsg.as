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
	import jp.nium.core.debug.Logger;
	import jp.nium.core.I18N.Locale;
	import jp.nium.core.L10N.L10NMsg;
	import jp.nium.core.L10N.L10NNiumMsg;
	
	/**
	 * @private
	 */
	public dynamic final class L10NWebLocalMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NWebLocalMsg = new L10NWebLocalMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const OPEN:String = "open";
		public const HISTORY_BACK:String = "historyBack";
		public const HISTORY_FORWARD:String = "historyForward";
		public const RELOAD:String = "Reload";
		public const OPEN_LINK_IN_NEW_WINDOW:String = "OpenLinkInNewWindow";
		public const COPY_LINK_LOCATION:String = "CopyLinkLocation";
		public const COPY_MAIL_ADDRESS:String = "CopyMailAddress";
		public const SAVE_TARGET_AS:String = "saveTargetAs";
		public const SHOW_PICTURE:String = "showPicture";
		public const PRINT_PICTURE:String = "printPicture";
		public const SEND_LINK:String = "SendLink";
		public const PRINT:String = "Print";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NWebLocalMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Locale.setString( OPEN, Locale.JAPANESE, "開く ...");
			Locale.setString( OPEN, Locale.ENGLISH, "Open ..." );
			Locale.setString( OPEN, Locale.FRENCH, "Ouvrir" );
			Locale.setString( OPEN, Locale.CHINESE, "開啓" );
			
			Locale.setString( HISTORY_BACK, Locale.JAPANESE, "前に戻る ..." );
			Locale.setString( HISTORY_BACK, Locale.ENGLISH, "Back ..." );
			Locale.setString( HISTORY_BACK, Locale.FRENCH, "Retourner" );
			Locale.setString( HISTORY_BACK, Locale.CHINESE, "上一頁" );
			
			Locale.setString( HISTORY_FORWARD, Locale.JAPANESE, "次に進む ..." );
			Locale.setString( HISTORY_FORWARD, Locale.ENGLISH, "Forward ..." );
			Locale.setString( HISTORY_FORWARD, Locale.FRENCH, "Avancer" );
			Locale.setString( HISTORY_FORWARD, Locale.CHINESE, "下一頁" );
			
			Locale.setString( RELOAD, Locale.JAPANESE, "更新 ..." );
			Locale.setString( RELOAD, Locale.ENGLISH, "Reload ..." );
			Locale.setString( RELOAD, Locale.FRENCH, "Rafraîchir" );
			Locale.setString( RELOAD, Locale.CHINESE, "更新" );
			
			Locale.setString( OPEN_LINK_IN_NEW_WINDOW, Locale.JAPANESE, "新規ウィンドウで開く ..." );
			Locale.setString( OPEN_LINK_IN_NEW_WINDOW, Locale.ENGLISH, "Open Link in New Window ..." );
			Locale.setString( OPEN_LINK_IN_NEW_WINDOW, Locale.FRENCH, "Ouvrir le lien dans une nouvelle fenêtre" );
			Locale.setString( OPEN_LINK_IN_NEW_WINDOW, Locale.CHINESE, "開啓新的視窗" );
			
			Locale.setString( COPY_LINK_LOCATION, Locale.JAPANESE, "対象の URL をコピー ..." );
			Locale.setString( COPY_LINK_LOCATION, Locale.ENGLISH, "Copy Link Location ..." );
			Locale.setString( COPY_LINK_LOCATION, Locale.FRENCH, "Copier le lien" );
			Locale.setString( COPY_LINK_LOCATION, Locale.CHINESE, "複製網址" );
			
			Locale.setString( COPY_MAIL_ADDRESS, Locale.JAPANESE, "メールアドレスをコピー ..." );
			Locale.setString( COPY_MAIL_ADDRESS, Locale.ENGLISH, "Copy Mail Address ..." );
			Locale.setString( COPY_MAIL_ADDRESS, Locale.FRENCH, "Copier l'addresse e-mail" );
			Locale.setString( COPY_MAIL_ADDRESS, Locale.CHINESE, "複製信箱地址" );
			
			Locale.setString( SAVE_TARGET_AS, Locale.JAPANESE, "対象をファイルに保存 ..." );
			Locale.setString( SAVE_TARGET_AS, Locale.ENGLISH, "Save Target As ..." );
			Locale.setString( SAVE_TARGET_AS, Locale.FRENCH, "Enregistrer sous" );
			Locale.setString( SAVE_TARGET_AS, Locale.CHINESE, "" );
			
			Locale.setString( SHOW_PICTURE, Locale.JAPANESE, "画像を表示 ..." );
			Locale.setString( SHOW_PICTURE, Locale.ENGLISH, "Show Picture ..." );
			Locale.setString( SHOW_PICTURE, Locale.FRENCH, "Afficher l'image" );
			Locale.setString( SHOW_PICTURE, Locale.CHINESE, "" );
			
			Locale.setString( PRINT_PICTURE, Locale.JAPANESE, "画像を印刷 ..." );
			Locale.setString( PRINT_PICTURE, Locale.ENGLISH, "Print Picture ..." );
			Locale.setString( PRINT_PICTURE, Locale.FRENCH, "Imprimer l'image" );
			Locale.setString( PRINT_PICTURE, Locale.CHINESE, "" );
			
			Locale.setString( SEND_LINK, Locale.JAPANESE, "URL をメールで送信 ..." );
			Locale.setString( SEND_LINK, Locale.ENGLISH, "Send Link ..." );
			Locale.setString( SEND_LINK, Locale.FRENCH, "Envoyer le lien" );
			Locale.setString( SEND_LINK, Locale.CHINESE, "將網址上傳至信箱" );
			
			Locale.setString( PRINT, Locale.JAPANESE, "印刷 ..." );
			Locale.setString( PRINT, Locale.ENGLISH, "Print ..." );
			Locale.setString( PRINT, Locale.FRENCH, "Imprimer" );
			Locale.setString( PRINT, Locale.CHINESE, "印刷" );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NWebLocalMsg {
			return _instance;
		}
	}
}
