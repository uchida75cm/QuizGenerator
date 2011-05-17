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
	
	/**
	 * <span lang="ja">指定された group と同じ値を持つ Resource インスタンスを含む配列を返します。</span>
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
	 * @see jp.progression.data.Resource#group
	 * 
	 * @example <listing version="3.0">
	 * // Resource インスタンスを作成する
	 * var res1:Resource = new Resource( "res1", "data1" );
	 * var res2:Resource = new Resource( "res2", "data2" );
	 * var res3:Resource = new Resource( "res3", "data3" );
	 * 
	 * // グループを設定する
	 * res1.group = "mygroup";
	 * res3.group = "mygroup";
	 * 
	 * // Resource インスタンスを取得する
	 * trace( getResourcesByGroup( "mygroup" ) ); // data1,data2 と出力
	 * </listing>
	 */
	public function getResourcesByGroup( group:String, sort:Boolean = false ):Array {
		return Resource.progression_internal::$collection.getInstancesByGroup( group, sort );
	}
}
