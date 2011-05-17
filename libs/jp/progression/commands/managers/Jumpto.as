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
package jp.progression.commands.managers {
	import jp.nium.core.debug.Logger;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	import jp.progression.core.L10N.L10NProgressionMsg;
	import jp.progression.core.ns.progression_internal;
	import jp.progression.Progression;
	import jp.progression.scenes.SceneId;
	
	/**
	 * <span lang="ja">Jumpto クラスは、指定されたシーン識別子の示すシーンに即移動するコマンドクラスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @example <listing version="3.0">
	 * // Jumpto インスタンスを作成する
	 * var com:Jumpto = new Jumpto();
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class Jumpto extends Command {
		
		/**
		 * <span lang="ja">移動先を示すシーン識別子を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get sceneId():SceneId { return _sceneId; }
		public function set sceneId( value:SceneId ):void { _sceneId = value; }
		private var _sceneId:SceneId;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい Jumpto インスタンスを作成します。</span>
		 * <span lang="en">Creates a new Jumpto object.</span>
		 * 
		 * @param sceneId
		 * <span lang="ja">移動先を示すシーン識別子です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function Jumpto( sceneId:SceneId, initObject:Object = null ) {
			// クラスをコンパイルに含める
			progression_internal;
			
			// 引数を設定する
			_sceneId = sceneId;
			
			// 親クラスを初期化する
			super( _executeFunction, null, initObject );
		}
		
		
		
		
		
		/**
		 * 実行されるコマンドの実装です。
		 */
		private function _executeFunction():void {
			// Progression を取得する
			var manager:Progression = Progression.progression_internal::$collection.getInstanceById( _sceneId.getNameByIndex( 0 ) ) as Progression;
			
			// 存在しなければ例外をスローする
			if ( !manager ) {
				super.throwError( this, new Error( Logger.getLog( L10NProgressionMsg.getInstance().ERROR_013 ).toString( _sceneId ) ) );
				return;
			}
			
			// 強制移動であり、すでに実行中であれば
			if ( manager.state > 0 ) {
				// 停止する
				manager.stop();
				
				// 移動する
				manager.jumpto( _sceneId, super.extra );
			}
			else {
				// 移動する
				manager.jumpto( _sceneId, super.extra );
				
				// 処理を終了する
				super.executeComplete();
			}
		}
		
		/**
		 * <span lang="ja">保持しているデータを解放します。</span>
		 * <span lang="en"></span>
		 */
		override public function dispose():void {
			// 親のメソッドを実行する
			super.dispose();
			
			_sceneId = null;
		}
		
		/**
		 * <span lang="ja">Jumpto インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an Jumpto subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい Jumpto インスタンスです。</span>
		 * <span lang="en">A new Jumpto object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new Jumpto( _sceneId, this );
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
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "sceneId" );
		}
	}
}
