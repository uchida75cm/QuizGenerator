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
package jp.progression.commands {
	import jp.progression.core.ns.progression_internal;
	
	/**
	 * <span lang="ja">指定された group と同じ値を持つ Command インスタンスを含む配列を返します。</span>
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
	 * @see jp.progression.commands.Command#group
	 * 
	 * @example <listing version="3.0">
	 * // Command インスタンスを作成する
	 * var com1:Command = new Command();
	 * var com2:Command = new Command();
	 * var com3:Command = new Command();
	 * 
	 * // id を設定する
	 * com1.id = "com1";
	 * com2.id = "com2";
	 * com3.id = "com3";
	 * 
	 * // グループを設定する
	 * com1.group = "mygroup";
	 * com3.group = "mygroup";
	 * 
	 * // Command インスタンスを取得する
	 * trace( getCommandsByGroup( "mygroup" ) ); // [object Command id="com1"],[object Command id="com3"] と出力
	 * </listing>
	 */
	public function getCommandsByGroup( group:String, sort:Boolean = false ):Array {
		return Command.progression_internal::$collection.getInstancesByGroup( group, sort );
	}
}
