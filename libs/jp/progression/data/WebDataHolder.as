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
package jp.progression.data {
	import jp.progression.core.ns.progression_internal;
	import jp.progression.events.ManagerEvent;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">WebDataHolder クラスは Web 用途に特化したデータ管理を行うモデルクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public class WebDataHolder extends DataHolder {
		
		/**
		 * @private
		 */
		progression_internal static var $htmlcontent:XML;
		
		
		
		
		
		/**
		 * <span lang="ja">Flash が設置されている HTML ファイルから、条件に合致するデータを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get html():XML { return new XML( _html.toXMLString() ); }
		private var _html:XML;
		
		/**
		 * <span lang="ja">対応する H* エレメントに設定されているストリングを取得します。</span>
		 * <span lang="en"></span>
		 */
		public function get heading():String { return _heading; }
		private var _heading:String;
		
		/**
		 * Progression インスタンスを取得します。
		 */
		private var _manaer:Progression;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい WebDataHolder インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebDataHolder object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい SceneObject インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function WebDataHolder( target:SceneObject ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 初期化する
			_html = new XML();
			
			// 親クラスを初期化する
			super( target );
			
			if ( !target.manager ) {
				// イベントリスナーを登録する
				target.addEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">保持しているデータを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #data
		 */
		override public function update():void {
			// 親クラスのメソッドを実行する
			super.update();
			
			// 更新する
			_update();
		}
		
		/**
		 * 
		 */
		private function _update():void {
			// HTML データを取得する
			var html:XML = progression_internal::$htmlcontent;
			
			// 存在しなければ終了する
			if ( !html ) { return; }
			
			// シーン識別子情報を取得する
			var sceneId:SceneId = super.target.sceneId;
			
			// 存在しなければ終了する
			if ( !sceneId ) { return; }
			
			// ショートパスを取得する
			var shortPath:String = sceneId.toShortPath();
			
			// 2 階層以下のシーンを指していれば
			if ( sceneId.length > 1 ) {
				// 合致するノードを取得する
				for each ( var div:XML in html..div ) {
					// 識別子が合致すれば
					if ( String( div.@id ) == shortPath ) {
						_html = div;
						break;
					}
				}
			}
			else {
				_html = html;
			}
			
			// 子の div タグを除去する
			while ( _html.div.length() > 0 ) {
				delete _html.div[0];
			}
			
			// h? 要素を取得する
			for each ( var h:XML in _html.* ) {
				if ( new RegExp( "^h[1-7]$" ).test( h.localName() ) ) {
					_heading = h.text();
					break;
				}
			}
			
			// シーンタイトルが存在しなければ、自動的に設定する
			if ( !super.target.title ) {
				super.target.title = _heading;
			}
			
			// データを保持する
			SceneObject.progression_internal::$providingData = super.data;
			
			// 更新する
			super.update();
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。
		 * dispose() メソッドが呼び出されると、それ以降はこのインスタンスのメソッドまたはプロパティを呼び出すと失敗し、例外がスローされます。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #data
		 */
		override public function dispose():void {
			// イベントリスナーを解除する
			super.target.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			super.target.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, _managerDeactivate );
			
			// 破棄する
			_html = null;
			
			super.dispose();
		}
		
		
		
		
		
		/**
		 * 
		 */
		private function _managerActivate( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			super.target.removeEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate );
			
			// Progression の参照を保持する
			_manaer = super.target.manager;
			
			// イベントリスナーを登録する
			_manaer.addEventListener( ManagerEvent.MANAGER_READY, _managerReady, false, int.MAX_VALUE );
			
			// 更新する
			_update();
		}
		
		/**
		 * 
		 */
		private function _managerDeactivate( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			super.target.removeEventListener( ManagerEvent.MANAGER_DEACTIVATE, _managerDeactivate );
			
			// 破棄する
			_manaer = null;
			
			// 初期化する
			_html = new XML();
			_heading = null;
		}
		
		/**
		 * 
		 */
		private function _managerReady( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			_manaer.removeEventListener( ManagerEvent.MANAGER_READY, _managerReady );
			
			// 更新する
			_update();
		}
	}
}
