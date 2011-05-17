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
package jp.progression.commands.display {
	import jp.nium.core.impls.IExDisplayObjectContainer;
	import jp.nium.utils.ObjectUtil;
	import jp.progression.commands.Command;
	
	/**
	 * <span lang="ja">AddChildAt クラスは、対象の表示リストに DisplayObject インスタンスを指定された位置に追加するコマンドクラスです。
	 * 追加するインスタンスが ICastObject インターフェイスを実装している場合には、CastEvent.CAST_ADDED イベントが送出され、
	 * 対象のイベント処理の実行中に、addCommand() メソッド、及び insertCommand() メソッドによるコマンドの同期処理が行えます。</span>
	 * <span lang="en"></span>
	 * 
	 * @see jp.progression.commands.display.AddChild
	 * @see jp.progression.commands.display.AddChildAt
	 * 
	 * @example <listing version="3.0">
	 * // CastSprite インスタンスを作成する
	 * var container:CastSprite = new CastSprite();
	 * var child:CastSprite = new CastSprite();
	 * 
	 * // AddChildAtAbove インスタンスを作成する
	 * var com:AddChildAtAbove = new AddChildAtAbove( container, child, 0 );
	 * 
	 * // コマンドを実行する
	 * com.execute();
	 * </listing>
	 */
	public class AddChildAtAbove extends AddChild {
		
		/**
		 * <span lang="ja">DisplayObject を追加するインデックス位置を取得または設定します。
		 * コマンド実行中に値を変更しても、処理に対して反映されません。</span>
		 * <span lang="en"></span>
		 */
		public function get index():int { return _index; }
		public function set index( value:int ):void { _index = value; }
		private var _index:int;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい AddChildAtAbove インスタンスを作成します。</span>
		 * <span lang="en">Creates a new AddChildAtAbove object.</span>
		 * 
		 * @param containerRefOrId
		 * <span lang="ja">指定された DisplayObject インスタンスを追加する対象の DisplayObjectContainer インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param childRefOrId
		 * <span lang="ja">表示リストに追加したい DisplayObject インスタンス、またはインスタンスを示す識別子です。</span>
		 * <span lang="en"></span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en"></span>
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function AddChildAtAbove( containerRefOrId:*, childRefOrId:*, index:int, initObject:Object = null ) {
			// 引数を設定する
			_index = index;
			
			// 親クラスを初期化する
			super( containerRefOrId, childRefOrId, initObject );
		}
		
		
		
		
		
		/**
		 * @private
		 */
		override internal function _addChildRef():void {
			// 表示リストに追加する
			IExDisplayObjectContainer( _containerRef ).addChildAtAbove( _childRef, _index );
		}
		
		/**
		 * <span lang="ja">AddChildAtAbove インスタンスのコピーを作成して、各プロパティの値を元のプロパティの値と一致するように設定します。</span>
		 * <span lang="en">Duplicates an instance of an AddChildAtAbove subclass.</span>
		 * 
		 * @return
		 * <span lang="ja">元のオブジェクトと同じプロパティ値を含む新しい AddChildAtAbove インスタンスです。</span>
		 * <span lang="en">A new AddChildAtAbove object that is identical to the original.</span>
		 */
		override public function clone():Command {
			return new AddChildAtAbove( super.container, super.child, _index, this );
		}
		
		/**
		 * <span lang="ja">指定されたオブジェクトのストリング表現を返します。</span>
		 * <span lang="en">Returns the string representation of the specified object.</span>
		 * 
		 * @return
		 * <span lang="ja">オブジェクトのストリング表現です。</span>
		 * <span lang="en">A string representation of the object.</span>
		 */
		override public function toString():String {
			return ObjectUtil.formatToString( this, super.className, super.id ? "id" : null, "container", "child", "index" );
		}
	}
}
