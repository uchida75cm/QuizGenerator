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
package jp.progression {
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">指定された group と同じ値を持つ Progression インスタンスを含む配列を返します。</span>
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
	 * @see jp.progression.Progression#group
	 * 
	 * @example <listing version="3.0">
	 * // Progression インスタンスを作成する
	 * var manager1:Progression = new Progression( "index1", stage );
	 * var manager2:Progression = new Progression( "index2", stage );
	 * var manager3:Progression = new Progression( "index3", stage );
	 * 
	 * // グループを設定する
	 * manager1.group = "mygroup";
	 * manager3.group = "mygroup";
	 * 
	 * // Progression インスタンスを取得する
	 * trace( getManagersByGroup( "mygroup" ) ); // [Progression id="index1"], [Progression id="index3"] と出力
	 * </listing>
	 */
	public function getManagersByGroup( group:String, sort:Boolean = false ):Array {
		return Progression.progression_internal::$collection.getInstancesByGroup( group, sort );
	}
}
