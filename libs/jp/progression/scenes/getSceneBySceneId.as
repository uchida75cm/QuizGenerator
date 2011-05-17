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
	 * <span lang="ja">指定されたシーン識別子と同じ値が設定されている SceneObject インスタンスを返します。</span>
	 * <span lang="en"></span>
	 * 
	 * @param sceneId
	 * <span lang="ja">条件となるシーン識別子です。</span>
	 * <span lang="en"></span>
	 * @return
	 * <span lang="ja">条件と一致するインスタンスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.scenes.SceneObject#id
	 * 
	 * @example <listing version="3.0">
	 * </listing>
	 */
	public function getSceneBySceneId( sceneId:SceneId ):SceneObject {
		return SceneObject.progression_internal::$getSceneBySceneId( sceneId );
	}
}
