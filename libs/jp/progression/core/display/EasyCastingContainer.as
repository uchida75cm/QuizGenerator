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
package jp.progression.core.display {
	import jp.progression.casts.CastSprite;
	import jp.progression.Progression;
	import jp.progression.scenes.EasyCastingScene;
	
	/**
	 * @private
	 * </listing>
	 */
	public final class EasyCastingContainer extends CastSprite {
		
		/**
		 * <span lang="ja">関連付けられている Progression インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		override public function get manager():Progression { return _scene.manager; }
		
		/**
		 * EasyCastingScene インスタンスを取得します。
		 */
		private var _scene:EasyCastingScene;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい EasyCastingContainer インスタンスを作成します。</span>
		 * <span lang="en">Creates a new EasyCastingContainer object.</span>
		 * 
		 * @param scene
		 * <span lang="ja">関連付けたい EasyCastingScene インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function EasyCastingContainer( scene:EasyCastingScene ) {
			// 引数を設定する
			_scene = scene;
		}
		
		
		
		
		
		/**
		 * <span lang="ja">マネージャーオブジェクトとの関連付けを更新します。</span>
		 * <span lang="en"></span>
		 * 
		 * @return
		 * <span lang="ja">関連付けが成功したら true を、それ以外は false を返します。</span>
		 * <span lang="en"></span>
		 * 
		 * @see #manager
		 * @see jp.progression.Progression
		 */
		public override function updateManager():Boolean {
			return Boolean( !!_scene.manager );
		}
	}
}
