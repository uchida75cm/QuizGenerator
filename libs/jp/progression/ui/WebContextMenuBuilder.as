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
package jp.progression.ui {
	import com.asual.swfaddress.SWFAddress;
	import flash.display.Bitmap;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.printing.PrintJob;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.escapeMultiByte;
	import jp.nium.core.I18N.Locale;
	import jp.nium.external.JavaScript;
	import jp.nium.utils.URLUtil;
	import jp.progression.core.impls.ICastButton;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NWebLocalMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.Progression;
	
	/**
	 * <span lang="ja">WebContextMenuBuilder クラスは、WebConfig として実装された場合に、一般的なブラウザ操作が行える機能をコンテクストメニューに実装するビルダークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class WebContextMenuBuilder implements IContextMenuBuilder {
		
		/**
		 * URL がメーラーのプロトコルを指しているかどうかを判別する正規表現を取得します。
		 */
		private static const _MAIL_ADDRESS_REGEXP:String = "^mailto:";
		
		/**
		 * ダウンロード対象となるファイル形式を判別する正規表現を取得します。
		 */
		private static const _DOWNLOADABLE_FORMAT_REGEXP:String = "[.](zip|lzh|cab|sit|rar|gca|gz|tgz|taz|hqx)$";
		
		/**
		 * 画像ファイル形式を判別する正規表現を取得します。
		 */
		private static const _IMAGE_FORMAT_REGEXP:String = "[.](jpg|jpeg|jpe|png|gif)$";
		
		/**
		 * <span lang="ja">ダウンロードに関連するオプションを有効化するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get useDownloadOption():Boolean { return _useDownloadOption; }
		public static function set useDownloadOption( value:Boolean ):void { _useDownloadOption = value; }
		private static var _useDownloadOption:Boolean = true;
		
		/**
		 * <span lang="ja">画像に関連するオプションを有効化するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get useImageOption():Boolean { return _useImageOption; }
		public static function set useImageOption( value:Boolean ):void { _useImageOption = value; }
		private static var _useImageOption:Boolean = true;
		
		/**
		 * <span lang="ja">印刷に関連するオプションを有効化するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public static function get usePrintOption():Boolean { return _usePrintOption; }
		public static function set usePrintOption( value:Boolean ):void { _usePrintOption = value; }
		private static var _usePrintOption:Boolean = true;
		
		
		
		
		
		/**
		 * <span lang="ja">関連付けられている InteractiveObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():InteractiveObject { return _target; }
		private var _target:InteractiveObject;
		
		/**
		 * Loader インスタンスを取得します。
		 */
		private var _loader:Loader;
		
		/**
		 * ICastButton インスタンスを取得します。
		 */
		private var _button:ICastButton;
		
		/**
		 * ContextMenu インスタンスを取得します。
		 */
		private var _menu:ContextMenu;
		
		/**
		 * ユーザー定義の ContextMenu インスタンスを取得します。
		 */
		private var _userDefinedMenu:ContextMenu;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WebContextMenuBuilder インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebContextMenuBuilder object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい InteractiveObject インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function WebContextMenuBuilder( target:InteractiveObject ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_target = target;
			
			// 対象の型別参照を取得する
			_loader = _target as Loader;
			_button = _target as ICastButton;
			
			// イベントリスナーを登録する
			if ( _button ) {
				_button.addEventListener( MouseEvent.ROLL_OVER, _rollOver );
				_button.addEventListener( MouseEvent.ROLL_OUT, _rollOut );
			}
			
			// ContextMenu を作成する
			_menu = new ContextMenu();
			
			// イベントリスナーを登録する
			_menu.addEventListener( ContextMenuEvent.MENU_SELECT, _menuSelect );
			
			// 既存のメニューを取得する
			_userDefinedMenu = _target.contextMenu as ContextMenu;
			if ( _userDefinedMenu ) {
				_menu.addEventListener( ContextMenuEvent.MENU_SELECT, _userDefinedMenu.dispatchEvent );
				_userDefinedMenu.addEventListener( ContextMenuEvent.MENU_SELECT, _menuSelect );
			}
			
			// ContextMenu を設定する
			_target.contextMenu = _menu;
		}
		
		
		
		
		
		/**
		 * 対象の示すべき URL を取得します。
		 */
		private function _toURL():String {
			var url:String = _target.stage.loaderInfo.url;
			
			// 対象に関連付けられた Progression を取得する
			var manageable:IManageable = _button as IManageable;
			var manager:Progression = manageable ? manageable.manager : null;
			
			// ブラウザ通信が有効化されていれば
			if ( JavaScript.enabled ) {
				url = JavaScript.locationHref;
			}
			
			// 対象がボタンであれば
			if ( _button ) {
				// シーン識別子が設定されていれば
				if ( manager && manager.sync && _button.sceneId ) {
					url = "#" + manager.root.localToGlobal( _button.sceneId ).toShortPath();
				}
				
				// href が設定されていれば
				if ( _button.href ) {
					url = _button.href;
				}
			}
			
			// url がメールアドレスを示していれば
			if ( new RegExp( _MAIL_ADDRESS_REGEXP, "gi" ).test( url ) ) { return url; }
			
			// ブラウザ通信が有効化されていれば
			if ( JavaScript.enabled ) {
				var href:String = JavaScript.locationHref;
				href = href.split( "#" )[0];
				
				return URLUtil.getAbsolutePath( url, href );
			}
			
			return URLUtil.getAbsolutePath( url, _target.stage.loaderInfo.url );
		}
		
		/**
		 * 
		 */
		private function _createCastObjectMenu( menu:ContextMenu ):void {
			// 新規メニュー項目を構築する
			var items:Array = [];
			var item:ContextMenuItem;
			
			var enabled:Boolean = JavaScript.enabled || Boolean( !!Progression.syncedManager );
			
			// 履歴を戻る
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().HISTORY_BACK ), true, enabled ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 履歴を進む
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().HISTORY_FORWARD ), false, enabled ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 更新する
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().RELOAD ), false, JavaScript.enabled ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 対象が示す URL を新しいウィンドウで開く
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().OPEN_LINK_IN_NEW_WINDOW ), true, true ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 対象が示す URL が画像であれば
			if ( _useImageOption && _loader && new RegExp( _IMAGE_FORMAT_REGEXP, "gi" ).test( _loader.contentLoaderInfo.url ) ) {
				// 対象が示す URL の画像を表示する
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().SHOW_PICTURE ), true, true ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				// 対象を印刷する
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().PRINT_PICTURE ), false, true ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// 対象が示す URL をコピーする
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().COPY_LINK_LOCATION ), true, true ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 対象が示す URL をメールで送信する
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().SEND_LINK ), false, true ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// ボタンではなければ
			if ( Capabilities.hasPrinting && _usePrintOption ) {
				// 印刷する
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().PRINT ), false, true ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// 権利表記
			switch ( Progression.config.activatedLicenseType ) {
				case "PLL Web"			:
				case "PLL Application"	: { break; }
				case "GPL"				:
				case "PLL Basic"		:
				default					: {
					items.push( item = new ContextMenuItem( Progression.progression_internal::$BUILT_ON_LABEL, true, true ) );
					item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				}
			}
			
			// 既存のカスタムメニューを取得する
			if ( _userDefinedMenu ) {
				items.unshift.apply( null, _userDefinedMenu.customItems.slice( 0, 15 - items.length ) );
			}
			
			// 既存のメニューを破棄する
			for ( var i:int = 0, l:int = menu.customItems.length; i < l; i++ ) {
				item = ContextMenuItem( menu.customItems[i] );
				item.removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// メニューに反映させる
			menu.customItems = items;
		}
		
		/**
		 * 
		 */
		private function _createCastButtonMenu( menu:ContextMenu ):void {
			var items:Array = [];
			var item:ContextMenuItem;
			
			var separateBefore:Boolean = true;
			
			var url:String = _toURL();
			var enabled:Boolean = Boolean( _button.sceneId || _button.href );
			
			// 対象が示す URL を開く
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().OPEN ), true, enabled ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 対象が示す URL を新しいウィンドウで開く
			items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().OPEN_LINK_IN_NEW_WINDOW ), false, enabled ) );
			item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			
			// 対象が示す URL がバイナリ形式であれば
			if ( _useDownloadOption && new RegExp( _DOWNLOADABLE_FORMAT_REGEXP, "gi" ).test( url ) ) {
				// 対象が示す URL のファイルを保存する
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().SAVE_TARGET_AS ), true, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				separateBefore = false;
			}
			
			if ( new RegExp( _MAIL_ADDRESS_REGEXP, "gi" ).test( url ) ) {
				// 対象が示すメールアドレスをコピーする
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().COPY_MAIL_ADDRESS ), true, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			else {
				// 対象が示す URL をコピーする
				items.push( item = new ContextMenuItem( Locale.getString( L10NWebLocalMsg.getInstance().COPY_LINK_LOCATION ), true, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// 権利表記
			switch ( Progression.config.activatedLicenseType ) {
				case "PLL Web"			:
				case "PLL Application"	: { break; }
				case "GPL"				:
				case "PLL Basic"		:
				default					: {
					items.push( item = new ContextMenuItem( Progression.progression_internal::$BUILT_ON_LABEL, true, true ) );
					item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				}
			}
			
			// 既存のカスタムメニューを取得する
			if ( _userDefinedMenu ) {
				items.unshift.apply( null, _userDefinedMenu.customItems.slice( 0, 15 - items.length ) );
			}
			
			// 既存のメニューを破棄する
			for ( var i:int = 0, l:int = menu.customItems.length; i < l; i++ ) {
				item = ContextMenuItem( menu.customItems[i] );
				item.removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// メニューに反映させる
			menu.customItems = items;
		}
		
		/**
		 * 
		 */
		private function _createCastTextFieldMenu( menu:ContextMenu ):void {
			var items:Array = [];
			var item:ContextMenuItem;
			
			// 権利表記
			switch ( Progression.config.activatedLicenseType ) {
				case "PLL Web"			:
				case "PLL Application"	: { break; }
				case "GPL"				:
				case "PLL Basic"		:
				default					: {
					items.push( item = new ContextMenuItem( Progression.progression_internal::$BUILT_ON_LABEL, true, true ) );
					item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				}
			}
			
			// 既存のカスタムメニューを取得する
			if ( _userDefinedMenu ) {
				items.unshift.apply( null, _userDefinedMenu.customItems.slice( 0, 15 - items.length ) );
			}
			
			// 既存のメニューを破棄する
			for ( var i:int = 0, l:int = menu.customItems.length; i < l; i++ ) {
				item = ContextMenuItem( menu.customItems[i] );
				item.removeEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
			}
			
			// メニューに反映させる
			menu.customItems = items;
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
			// イベントリスナーを解除する
			_target.removeEventListener( MouseEvent.ROLL_OVER, _rollOver );
			_target.removeEventListener( MouseEvent.ROLL_OUT, _rollOut );
			
			// 既存のメニューを破棄する
			if ( _userDefinedMenu ) {
				_menu.removeEventListener( ContextMenuEvent.MENU_SELECT, _userDefinedMenu.dispatchEvent );
				_userDefinedMenu.removeEventListener( ContextMenuEvent.MENU_SELECT, _menuSelect );
				_target.contextMenu = _userDefinedMenu;
				_userDefinedMenu = null;
			}
			
			// データを破棄する
			_target = null;
			_menu = null;
		}
		
		
		
		
		
		/**
		 * ユーザーが InteractiveObject インスタンスにポインティングデバイスを合わせたときに送出されます。
		 */
		private function _rollOver( e:MouseEvent ):void {
			// ブラウザのステータスを設定する
			SWFAddress.setStatus( _toURL() || "" );
		}
		
		/**
		 * ユーザーが InteractiveObject インスタンスからポインティングデバイスを離したときに送出されます。
		 */
		private function _rollOut( e:MouseEvent ):void {
			// ブラウザのステータスを破棄する
			SWFAddress.setStatus( "" );
		}
		
		/**
		 * ユーザーが最初にコンテキストメニューを生成したときに、コンテキストメニューの内容が表示される前に送出されます。
		 */
		private function _menuSelect( e:ContextMenuEvent ):void {
			var menu:ContextMenu = _menu;
			
			if ( e.mouseTarget && "__progressionCurrentButton__" in e.mouseTarget ) {
				try {
					menu = ContextMenu( e.mouseTarget ? e.mouseTarget.contextMenu : e.target ) || _menu;
				}
				catch ( err:Error ) {
					menu = _menu;
				}
			}
			
			// 既存のメニューを非表示にする
			menu.hideBuiltInItems();
			
			if ( e.mouseTarget is TextField ) {
				_createCastTextFieldMenu( menu );
			}
			else if ( _button ) {
				_createCastButtonMenu( menu );
			}
			else {
				_createCastObjectMenu( menu );
			}
			
			// 現在のノードおよび後続するノードで、イベントリスナーが処理されないようにする
			e.stopPropagation();
		}
		
		/**
		 * ユーザーがコンテキストメニューからアイテムを選択したときに送出されます。
		 */
		private function _menuItemSelect( e:ContextMenuEvent ):void {
			// 項目を取得する
			var item:ContextMenuItem = ContextMenuItem( e.target );
			
			switch ( item.caption ) {
				case Locale.getString( L10NWebLocalMsg.getInstance().HISTORY_BACK )					: {
					if ( JavaScript.enabled ) {
						SWFAddress.back();
					}
					else if ( Progression.syncedManager ) {
						Progression.syncedManager.history.back();
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().HISTORY_FORWARD )				: {
					if ( JavaScript.enabled ) {
						SWFAddress.forward();
					}
					else if ( Progression.syncedManager ) {
						Progression.syncedManager.history.forward();
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().RELOAD )						: { JavaScript.reload( true ); break; }
				case Locale.getString( L10NWebLocalMsg.getInstance().OPEN_LINK_IN_NEW_WINDOW )		: {
					if ( _button ) {
						_button.navigateTo( _toURL(), "_blank" );
					}
					else {
						navigateToURL( new URLRequest( _toURL() ), "_blank" );
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().SHOW_PICTURE )					: { navigateToURL( new URLRequest( _loader.contentLoaderInfo.url ) ); break; }
				case Locale.getString( L10NWebLocalMsg.getInstance().PRINT_PICTURE )				: {
					var bmp:Bitmap = _loader.content as Bitmap;
					
					if ( !bmp ) { return; }
					
					var sp:Sprite = new Sprite();
					sp.addChild( new Bitmap( bmp.bitmapData ) );
					
					var job:PrintJob = new PrintJob();
					if ( job.start() ) {
						job.addPage( sp );
						job.send();
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().SAVE_TARGET_AS )				: { navigateToURL( new URLRequest( _toURL() ) ); break; }
				case Locale.getString( L10NWebLocalMsg.getInstance().COPY_LINK_LOCATION )			: { System.setClipboard( _toURL() ); break; }
				case Locale.getString( L10NWebLocalMsg.getInstance().SEND_LINK )					: {
					var url:String = "mailto:?body=" + escape( _toURL() ) + "%0D%0A";
					
					if ( JavaScript.enabled ) {
						url += "&subject=" + escapeMultiByte( JavaScript.documentTitle );
						JavaScript.locationHref = url;
					}
					else {
						navigateToURL( new URLRequest( url ) );
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().PRINT )						: {
					if ( JavaScript.enabled ) {
						JavaScript.print();
					}
					else {
						job = new PrintJob();
						if ( job.start() ) {
							job.addPage( Sprite( _target.root ) );
							job.send();
						}
					}
					break;
				}
				case Locale.getString( L10NWebLocalMsg.getInstance().OPEN )							: { _button.navigateTo( _toURL() ); break; }
				case Locale.getString( L10NWebLocalMsg.getInstance().COPY_MAIL_ADDRESS )			: { System.setClipboard( _toURL().replace( new RegExp( _MAIL_ADDRESS_REGEXP, "ig" ), "" ) ); break; }
				case Progression.progression_internal::$BUILT_ON_LABEL								: { navigateToURL( new URLRequest( Progression.progression_internal::$BUILT_ON_URL ), Progression.URL ); break; }
			}
		}
	}
}
