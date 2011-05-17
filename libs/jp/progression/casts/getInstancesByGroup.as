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
package jp.progression.casts {
	import jp.nium.core.ns.nium_internal;
	import jp.nium.display.ExMovieClip;
	
	/**
	 * <span lang="ja">指定された group と同じ値を持つ IExDisplayObject インスタンスを含む配列を返します。</span>
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
	 * @see jp.nium.core.display.IExDisplayObject#group
	 * 
	 * @example <listing version="3.0">
	 * // CastSprite インスタンスを作成する
	 * var cast1:CastSprite = new CastSprite();
	 * var cast2:CastSprite = new CastSprite();
	 * var cast3:CastSprite = new CastSprite();
	 * 
	 * // id を設定する
	 * cast1.id = "cast1";
	 * cast2.id = "cast2";
	 * cast3.id = "cast3";
	 * 
	 * // グループを設定する
	 * cast1.group = "mygroup";
	 * cast3.group = "mygroup";
	 * 
	 * // CastSprite インスタンスを取得する
	 * trace( getInstancesByGroup( "mygroup" ) ); // [object CastSprite id="cast1"],[object CastSprite id="cast3"] と出力
	 * </listing>
	 */
	public function getInstancesByGroup( group:String, sort:Boolean = false ):Array {
		return ExMovieClip.nium_internal::$collection.getInstancesByGroup( group, sort );
	}
}
