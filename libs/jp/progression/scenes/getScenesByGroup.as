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
	 * <span lang="ja">指定された group と同じ値を持つ SceneObject インスタンスを含む配列を返します。</span>
	 * <span lang="en"></span>
	 * 
	 * @param group
	 * <span lang="ja">条件となるストリングです。</span>
	 * <span lang="en"></span>
	 * @param sort
	 * <span lang="ja">結果の配列をソートして返すかどうかを指定します。</span>
	 * <span lang="en"></span>
	 * @return
	 * <span lang="ja">条件と一致するインスタンスを含む配列です。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.scenes.SceneObject#group
	 * 
	 * @example <listing version="3.0">
	 * // SceneObject インスタンスを作成する
	 * var scene1:SceneObject = new SceneObject( "scene1" );
	 * var scene2:SceneObject = new SceneObject( "scene2" );
	 * var scene3:SceneObject = new SceneObject( "scene3" );
	 * 
	 * // グループを設定する
	 * scene1.group = "mygroup";
	 * scene3.group = "mygroup";
	 * 
	 * // SceneObject インスタンスを取得する
	 * trace( getScenesByGroup( "mygroup" ) ); // [object SceneObject name="scene1"],[object SceneObject name="scene3"] と出力
	 * </listing>
	 */
	public function getScenesByGroup( group:String, sort:Boolean = false ):Array {
		return SceneObject.progression_internal::$collection.getInstancesByGroup( group, sort );
	}
}
