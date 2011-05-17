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
	import flash.display.InteractiveObject;
	import flash.display.StageDisplayState;
	import flash.events.ContextMenuEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import jp.nium.core.I18N.Locale;
	import jp.progression.core.impls.IManageable;
	import jp.progression.core.L10N.L10NSlideLocalMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">SlideContextMenuBuilder クラスは、SlideConfig として実装された場合に、PowerPoint に類似した操作機能をコンテクストメニューに実装するビルダークラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class SlideContextMenuBuilder implements IContextMenuBuilder {
		
		/**
		 * <span lang="ja">関連付けられている InteractiveObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get target():InteractiveObject { return _target; }
		private var _target:InteractiveObject;
		
		/**
		 * IManageable インスタンスを取得する。
		 */
		private var _manageable:IManageable;
		
		/**
		 * ContextMenu インスタンスを取得する。
		 */
		private var _menu:ContextMenu;
		
		/**
		 * ユーザー定義の ContextMenu インスタンスを取得します。
		 */
		private var _userDefinedMenu:ContextMenu;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい SlideContextMenuBuilder インスタンスを作成します。</span>
		 * <span lang="en">Creates a new SlideContextMenuBuilder object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい InteractiveObject インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function SlideContextMenuBuilder( target:InteractiveObject ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_target = target;
			
			// 対象の型別参照を取得する
			_manageable = _target as IManageable;
			
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
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		public function dispose():void {
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
			
			// 新規メニュー項目を構築する
			var items:Array = [];
			var item:ContextMenuItem;
			
			var enabled:Boolean = Boolean( !!_manageable );
			
			if ( !( e.mouseTarget is TextField ) ) {
				items.push( item = new ContextMenuItem( Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_NEXT_SLIDE ), true, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				items.push( item = new ContextMenuItem( Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_PREVIOUS_SLIDE ), false, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				items.push( item = new ContextMenuItem( Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_FIRST_SLIDE ), true, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				items.push( item = new ContextMenuItem( Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_LAST_SLIDE ), false, enabled ) );
				item.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _menuItemSelect );
				
				items.push( item = new ContextMenuItem( Locale.getString( L10NSlideLocalMsg.getInstance().FULL_SCREEN ), true, true ) );
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
			
			// 現在のノードおよび後続するノードで、イベントリスナーが処理されないようにする
			e.stopPropagation();
		}
		
		/**
		 * ユーザーがコンテキストメニューからアイテムを選択したときに送出されます。
		 */
		private function _menuItemSelect( e:ContextMenuEvent ):void {
			// 項目を取得する
			var item:ContextMenuItem = ContextMenuItem( e.target );
			
			// Progression インスタンスを取得する
			var manager:Progression = _manageable.manager;
			
			switch ( item.caption ) {
				case Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_NEXT_SLIDE )		: {
					// 存在しなければ終了する
					if ( !manager || !manager.current || !manager.current.next ) { return; }
					
					// 次のシーンに移動する
					manager.goto( manager.current.next.sceneId );
					break;
				}
				case Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_PREVIOUS_SLIDE )	: {
					// 存在しなければ終了する
					if ( !manager || !manager.current || !manager.current.next ) { return; }
					
					// 前のシーンに移動する
					manager.goto( manager.current.previous.sceneId );
					break;
				}
				case Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_FIRST_SLIDE )		: {
					// 存在しなければ終了する
					if ( !manager || !manager.current || !manager.current.next ) { return; }
					
					// 最初のシーンに移動する
					manager.goto( manager.current.parent.scenes[0].sceneId );
					break;
				}
				case Locale.getString( L10NSlideLocalMsg.getInstance().JUMP_LAST_SLIDE )		: {
					// 存在しなければ終了する
					if ( !manager || !manager.current || !manager.current.next ) { return; }
					
					// 最後のシーンに移動する
					var parent:SceneObject = manager.current.parent;
					manager.goto( parent.scenes[parent.numScenes - 1].sceneId );
					break;
				}
				case Locale.getString( L10NSlideLocalMsg.getInstance().FULL_SCREEN )			: {
					try {
						_target.stage.displayState = StageDisplayState.FULL_SCREEN;
					}
					catch ( err:Error ) {}
					break;
				}
				case Progression.progression_internal::$BUILT_ON_LABEL							: { navigateToURL( new URLRequest( Progression.progression_internal::$BUILT_ON_URL ), Progression.URL ); break; }
			}
		}
	}
}
