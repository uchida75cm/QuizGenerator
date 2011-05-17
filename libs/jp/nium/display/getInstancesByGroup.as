/**
 * jp.nium Classes
 * 
 * @author Copyright (C) 2007-2010 taka:nium.jp, All Rights Reserved.
 * @version 4.0.22
 * @see http://classes.nium.jp/
 * 
 * jp.nium Classes is released under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 */
package jp.nium.display {
	import jp.nium.core.ns.nium_internal;
	
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
	 * // ExSprite インスタンスを作成する
	 * var sp1:ExSprite = new ExSprite();
	 * var sp2:ExSprite = new ExSprite();
	 * var sp3:ExSprite = new ExSprite();
	 * 
	 * // id を設定する
	 * sp1.id = "sp1";
	 * sp2.id = "sp2";
	 * sp3.id = "sp3";
	 * 
	 * // グループを設定する
	 * sp1.group = "mygroup";
	 * sp3.group = "mygroup";
	 * 
	 * // ExSprite インスタンスを取得する
	 * trace( getInstancesByGroup( "mygroup" ) ); // [object ExSprite id="sp1"],[object ExSprite id="sp3"] と出力
	 * </listing>
	 */
	public function getInstancesByGroup( group:String, sort:Boolean = false ):Array {
		return ExMovieClip.nium_internal::$collection.getInstancesByGroup( group, sort );
	}
}
