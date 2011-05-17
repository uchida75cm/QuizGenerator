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
package jp.progression.casts.buttons {
	import jp.nium.core.debug.Logger;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.core.display.ButtonBase;
	import jp.progression.events.ManagerEvent;
	import jp.progression.events.ProcessEvent;
	import jp.progression.scenes.SceneId;
	import jp.progression.scenes.SceneObject;
	
	/**
	 * <span lang="ja">PreviousButton クラスは、現在のシーン位置を基準として前のシーンに相当する対象に移動するボタン機能を提供するコンポーネントクラスです。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // PreviousButton インスタンスを作成する
	 * var cast:PreviousButton = new PreviousButton();
	 * cast.graphics.beginFill( 0x000000 );
	 * cast.graphics.drawRect( 0, 0, 100, 100 );
	 * cast.graphics.endFill();
	 * 
	 * // 関連付けたいマネージャー識別子を設定する
	 * cast.managerId = "index";
	 * 
	 * // SerialList コマンドを実行する
	 * new SerialList( null,
	 * 	// 画面に表示する
	 * 	new AddChild( this, cast ),
	 * 	
	 * 	// 画面から消去する
	 * 	new RemoveChild( this, cast )
	 * ).execute();
	 * </listing>
	 */
	public class PreviousButton extends ButtonBase {
		
		/**
		 * <span lang="ja">関連付けたい Progression 識別子を示すストリングを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get managerId():String { return _managerId; }
		public function set managerId( value:String ):void {
			// 書式が正しければ
			if ( SceneId.validateName( value ) ) {
				// 変更されているかどうかを取得する
				var changed:Boolean = ( _managerId != value );
				
				// 更新する
				_managerId = value;
				
				// sceneId を設定する
				if ( changed ) {
					super.sceneId = new SceneId( "/" + value );
				}
			}
			else if ( value ) {
				Logger.error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_005 ).toString( value ) );
			}
			else {
				// sceneId を設定する
				super.sceneId = null;
				
				// 更新する
				_managerId = value;
			}
		}
		private var _managerId:String;
		
		/**
		 * <span lang="ja">前のシーンが存在しない場合に、一番後方のシーンに移動するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get useTurnBack():Boolean { return _useTurnBack; }
		public function set useTurnBack( value:Boolean ):void { _useTurnBack = value; }
		private var _useTurnBack:Boolean = false;
		
		/**
		 * <span lang="ja">キーボードの左矢印キーを押した際にボタンを有効化するかどうかを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get useLeftKey():Boolean { return _useLeftKey; }
		public function set useLeftKey( value:Boolean ):void { _useLeftKey = value; }
		private var _useLeftKey:Boolean = true;
		
		/**
		 * @private
		 */
		override public function get sceneId():SceneId { return super.sceneId; }
		override public function set sceneId( value:SceneId ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "sceneId" ) ); }
		
		/**
		 * @private
		 */
		override public function get href():String { return super.href; }
		override public function set href( value:String ):void { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_001 ).toString( "href" ) ); }
		
		
		
		
		
		/**
		 * <span lang="ja">新しい PreviousButton インスタンスを作成します。</span>
		 * <span lang="en">Creates a new PreviousButton object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function PreviousButton( initObject:Object = null ) {
			// 親クラスを初期化する
			super( initObject );
			
			// イベントリスナーを登録する
			super.addEventListener( ManagerEvent.MANAGER_ACTIVATE, _managerActivate, false, 0, true );
			super.addEventListener( ManagerEvent.MANAGER_DEACTIVATE, _managerDeactivate, false, 0, true );
			
			// Progression インスタンスと関連付けられていれば
			if ( super.manager ) {
				_managerActivate( new ManagerEvent( ManagerEvent.MANAGER_ACTIVATE, false, false, super.manager ) );
			}
		}
		
		
		
		
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "managerId", "useTurnBack", "useLeftKey" );
		}
		
		
		
		
		
		/**
		 * キャストオブジェクトと Progression インスタンスの関連付けがアクティブになったときに送出されます。
		 */
		private function _managerActivate( e:ManagerEvent ):void {
			// イベントリスナーを登録する
			e.managerTarget.addEventListener( ProcessEvent.PROCESS_SCENE, _processScene );
			
			// 更新する
			_processScene( null );
		}
		
		/**
		 * キャストオブジェクトと Progression インスタンスの関連付けが非アクティブになったときに送出されます。
		 */
		private function _managerDeactivate( e:ManagerEvent ):void {
			// イベントリスナーを解除する
			e.managerTarget.removeEventListener( ProcessEvent.PROCESS_SCENE, _processScene );
		}
		
		/**
		 * 管理下にあるシーンの移動処理中に対象シーンが変更された場合に送出されます。
		 */
		private function _processScene( e:ProcessEvent ):void {
			// 現在のカレントシーンを取得する
			var current:SceneObject = super.manager.current;
			
			// 存在しなければ終了する
			if ( !current ) { return; }
			
			// 現在の親子関係を取得する
			var previous:SceneObject = current.previous;
			var parent:SceneObject = current.parent;
			previous ||= ( parent && _useTurnBack ) ? parent.getSceneAt( parent.numScenes - 1 ) : current;
			
			// 移動先を指定する
			super.sceneId = previous.sceneId;
		}
	}
}
