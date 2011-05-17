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
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.scenes.SceneId;
	
	/**
	 * <span lang="ja">RollOverButton クラスは、任意のシーンに移動するボタン機能を提供するコンポーネントクラスです。
	 * このクラスを使用するためには、CommandExecutor が実装される環境設定（BasicAppConfig、WebConfig、等）を使用する必要があります。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // RollOverButton インスタンスを作成する
	 * var cast:RollOverButton = new RollOverButton();
	 * cast.graphics.beginFill( 0x000000 );
	 * cast.graphics.drawRect( 0, 0, 100, 100 );
	 * cast.graphics.endFill();
	 * 
	 * // クリック時の移動先を設定する
	 * cast.scenePath = "/index";
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
	public class RollOverButton extends ButtonBase {
		
		/**
		 * <span lang="ja">ボタンがクリックされた時の移動先を示すシーンパスを取得または設定します。</span>
		 * <span lang="en"></span>
		 */
		public function get scenePath():String { return _scenePath; }
		public function set scenePath( value:String ):void {
			// 書式が正しければ
			if ( SceneId.validatePath( value ) ) {
				// sceneId を設定する
				super.sceneId = new SceneId( value );
				
				// 更新する
				_scenePath = value;
			}
			else if ( value ) {
				Logger.error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_013 ).toString( value ) );
			}
			else {
				// sceneId を設定する
				super.sceneId = null;
				
				// 更新する
				_scenePath = value;
			}
		}
		private var _scenePath:String;
		
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
		 * <span lang="ja">新しい RollOverButton インスタンスを作成します。</span>
		 * <span lang="en">Creates a new RollOverButton object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function RollOverButton( initObject:Object = null ) {
			// 親クラスを初期化する
			super( initObject );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "scenePath" );
		}
	}
}
