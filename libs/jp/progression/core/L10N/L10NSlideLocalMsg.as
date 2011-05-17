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
	public dynamic final class L10NSlideLocalMsg extends L10NMsg {
		
		/**
		 * @private
		 */
		private static const _instance:L10NSlideLocalMsg = new L10NSlideLocalMsg();
		
		
		
		
		
		/**
		 * @private
		 */
		public const JUMP_NEXT_SLIDE:String = "jumpNextSlide";
		public const JUMP_PREVIOUS_SLIDE:String = "jumpPreviousSlide";
		public const JUMP_FIRST_SLIDE:String = "jumpFirstSlide";
		public const JUMP_LAST_SLIDE:String = "jumpLastSlide";
		public const FULL_SCREEN:String = "fullScreen";
		
		
		
		
		
		/**
		 * @private
		 */
		public function L10NSlideLocalMsg() {
			if ( _instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_010 ).toString( super.className ) ); }
			
			Locale.setString( JUMP_NEXT_SLIDE, Locale.JAPANESE, "次へ ..." );
			Locale.setString( JUMP_NEXT_SLIDE, Locale.ENGLISH, "Go to Next Slide ..." );
			Locale.setString( JUMP_NEXT_SLIDE, Locale.FRENCH, "Aller à la page suivante" );
			Locale.setString( JUMP_NEXT_SLIDE, Locale.CHINESE, "" );
			
			Locale.setString( JUMP_PREVIOUS_SLIDE, Locale.JAPANESE, "前へ ..." );
			Locale.setString( JUMP_PREVIOUS_SLIDE, Locale.ENGLISH, "Go to Previous Slide ..." );
			Locale.setString( JUMP_PREVIOUS_SLIDE, Locale.FRENCH, "Retourner à la page précédante" );
			Locale.setString( JUMP_PREVIOUS_SLIDE, Locale.CHINESE, "" );
			
			Locale.setString( JUMP_FIRST_SLIDE, Locale.JAPANESE, "最初のスライド ..." );
			Locale.setString( JUMP_FIRST_SLIDE, Locale.ENGLISH, "Jump to First Slide ..." );
			Locale.setString( JUMP_FIRST_SLIDE, Locale.FRENCH, "Aller à la première page" );
			Locale.setString( JUMP_FIRST_SLIDE, Locale.CHINESE, "" );
			
			Locale.setString( JUMP_LAST_SLIDE, Locale.JAPANESE, "最後のスライド ..." );
			Locale.setString( JUMP_LAST_SLIDE, Locale.ENGLISH, "Jump to Last Slide ..." );
			Locale.setString( JUMP_LAST_SLIDE, Locale.FRENCH, "Aller à la dernière page" );
			Locale.setString( JUMP_LAST_SLIDE, Locale.CHINESE, "" );
			
			Locale.setString( FULL_SCREEN, Locale.JAPANESE, "全画面表示 ..." );
			Locale.setString( FULL_SCREEN, Locale.ENGLISH, "Full Screen ..." );
			Locale.setString( FULL_SCREEN, Locale.FRENCH, "Plein écran" );
			Locale.setString( FULL_SCREEN, Locale.CHINESE, "" );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		public static function getInstance():L10NSlideLocalMsg {
			return _instance;
		}
	}
}
