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
package jp.progression.core.impls {
	import flash.events.IEventDispatcher;
	import jp.progression.executors.ExecutorObject;
	
	/**
	 * @private
	 */
	public interface IExecutable extends IEventDispatcher {
		
		/**
		 * <span lang="ja">関連付けられている ExecutorObject インスタンスを取得します。</span>
		 * <span lang="en"></span>
		 */
		function get executor():ExecutorObject;
	}
}
