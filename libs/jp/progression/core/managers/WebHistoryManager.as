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
package jp.progression.core.managers {
	import com.asual.swfaddress.SWFAddress;
	import jp.nium.external.JavaScript;
	import jp.progression.Progression;
	
	/**
	 * @private
	 */
	public class WebHistoryManager extends HistoryManager implements IHistoryManager {
		
		/**
		 * <span lang="ja">新しい WebHistoryManager インスタンスを作成します。</span>
		 * <span lang="en">Creates a new WebHistoryManager object.</span>
		 * 
		 * @param target
		 * <span lang="ja">関連付けたい Progression インスタンスです。</span>
		 * <span lang="en"></span>
		 */
		public function WebHistoryManager( target:Progression ) {
			// 親クラスを初期化する
			super( target );
		}
		
		
		
		
		/**
		 * <span lang="ja">履歴を一つ次に進みます。</span>
		 * <span lang="en"></span>
		 */
		public override function forward():void {
			if ( super.target.sync && JavaScript.enabled ) {
				SWFAddress.forward();
			}
			else {
				super.forward();
			}
		}
		
		/**
		 * <span lang="ja">履歴を一つ前に戻ります。</span>
		 * <span lang="en"></span>
		 */
		public override function back():void {
			if ( super.target.sync && JavaScript.enabled ) {
				SWFAddress.back();
			}
			else {
				super.back();
			}
		}
		
		/**
		 * <span lang="ja">履歴を特定の位置に移動します。</span>
		 * <span lang="en"></span>
		 * 
		 * @param position
		 * <span lang="ja">移動位置を示す数値です。</span>
		 * <span lang="en"></span>
		 */
		public override function go( position:int ):void {
			if ( super.target.sync && JavaScript.enabled ) {
				SWFAddress.go( position );
			}
			else {
				super.go( position );
			}
		}
	}
}
