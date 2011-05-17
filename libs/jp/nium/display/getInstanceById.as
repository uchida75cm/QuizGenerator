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
	import flash.display.DisplayObject;
	import jp.nium.core.ns.nium_internal;
	
	/**
	 * <span lang="ja">指定された id と同じ値が設定されている IExDisplayObject インスタンスを返します。</span>
	 * <span lang="en"></span>
	 * 
	 * @param id
	 * <span lang="ja">条件となるストリングです。</span>
	 * <span lang="en"></span>
	 * @return
	 * <span lang="ja">条件と一致するインスタンスです。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.nium.core.display.IExDisplayObject#id
	 * 
	 * @example <listing version="3.0">
	 * // ExSprite インスタンスを作成する
	 * var mysp:ExSprite = new ExSprite();
	 * 
	 * // id を設定する
	 * mysp.id = "mysp";
	 * 
	 * // ExSprite インスタンスを取得する
	 * trace( getInstanceById( "mysp" ) ); // [object ExSprite id="mysp"] と出力
	 * </listing>
	 */
	public function getInstanceById( id:String ):DisplayObject {
		return ExMovieClip.nium_internal::$collection.getInstanceById( id ) as DisplayObject;
	}
}
