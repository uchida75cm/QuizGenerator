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
package jp.progression.scenes {
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">指定された id と同じ値が設定されている SceneObject インスタンスを返します。</span>
	 * <span lang="en"></span>
	 * 
	 * @param id
	 * <span lang="ja">条件となるストリングです。</span>
	 * <span lang="en"></span>
	 * @return
	 * <span lang="ja">条件と一致するインスタンスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.scenes.SceneObject#id
	 * 
	 * @example <listing version="3.0">
	 * // SceneObject インスタンスを作成する
	 * var scene:SceneObject = new SceneObject();
	 * 
	 * // id を設定する
	 * scene.id = "myscene";
	 * 
	 * // SceneObject インスタンスを取得する
	 * trace( getSceneById( "myscene" ) ); // [object SceneObject id="myscene"] と出力
	 * </listing>
	 */
	public function getSceneById( id:String ):SceneObject {
		return SceneObject.progression_internal::$collection.getInstanceById( id ) as SceneObject;
	}
}
