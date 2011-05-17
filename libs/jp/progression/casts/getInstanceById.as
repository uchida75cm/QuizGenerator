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
	import flash.display.DisplayObject;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.display.ExMovieClip;
	
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
	 * // CastSprite インスタンスを作成する
	 * var mycast:CastSprite = new CastSprite();
	 * 
	 * // id を設定する
	 * mycast.id = "mycast";
	 * 
	 * // CastSprite インスタンスを取得する
	 * trace( getInstanceById( "mycast" ) ); // [object CastSprite id="mycast"] と出力
	 * </listing>
	 */
	public function getInstanceById( id:String ):DisplayObject {
		return ExMovieClip.nium_internal::$collection.getInstanceById( id ) as DisplayObject;
	}
}
