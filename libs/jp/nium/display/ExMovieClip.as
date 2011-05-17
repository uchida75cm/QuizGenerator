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
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventPhase;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import jp.nium.collections.IdGroupCollection;
	import jp.nium.collections.IIdGroup;
	import jp.nium.core.debug.Logger;
	import jp.nium.core.impls.IExDisplayObjectContainer;
	import jp.nium.core.L10N.L10NNiumMsg;
	import jp.nium.core.ns.nium_internal;
	import jp.nium.core.primitives.StringObject;
	import jp.nium.impls.IDisplayObjectContainer;
	import jp.nium.utils.ClassUtil;
	import jp.nium.utils.ObjectUtil;
	
	/**
	 * <span lang="ja">ExMovieClip クラスは、MovieClip クラスの基本機能を拡張した jp.nium パッケージで使用される基本的な表示オブジェクトクラスです。</span>
	 * <span lang="en">ExMovieClip class is a basic display object class used at jp.nium package which extends the basic function of MovieClip class.</span>
	 * 
	 * @see jp.nium.display#getInstanceById()
	 * @see jp.nium.display#getInstancesByGroup()
	 * 
	 * @example <listing version="3.0">
	 * // ExMovieClip インスタンスを作成する
	 * var mc:ExMovieClip = new ExMovieClip();
	 * </listing>
	 */
	public class ExMovieClip extends MovieClip implements IDisplayObjectContainer, IExDisplayObjectContainer, IIdGroup {
		
		/**
		 * @private
		 */
		nium_internal static var $collection:IdGroupCollection = new IdGroupCollection();
		
		
		
		
		/**
		 * <span lang="ja">インスタンスのクラス名を取得します。</span>
		 * <span lang="en">Indicates the instance className of the IExDisplayObject.</span>
		 */
		public function get className():String { return _classNameObj ? _classNameObj.toString() : ClassUtil.nium_internal::$DEFAULT_CLASS_NAME; }
		private var _classNameObj:StringObject;
		
		/**
		 * <span lang="ja">インスタンスの識別子を取得または設定します。</span>
		 * <span lang="en">Indicates the instance id of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstanceById()
		 */
		public function get id():String { return _id; }
		public function set id( value:String ):void {
			// 既存の登録を取得する
			var instance:IIdGroup = ExMovieClip.nium_internal::$collection.getInstanceById( value );
			
			// すでに存在していれば例外をスローする
			if ( instance ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_022 ).toString( value ) ); }
			
			// 登録する
			_id = ExMovieClip.nium_internal::$collection.registerId( this, value ) ? value : null;
		}
		private var _id:String;
		
		/**
		 * <span lang="ja">インスタンスのグループ名を取得または設定します。</span>
		 * <span lang="en">Indicates the instance group of the IExDisplayObject.</span>
		 * 
		 * @see jp.nium.display#getInstancesByGroup()
		 */
		public function get group():String { return _group; }
		public function set group( value:String ):void { _group = ExMovieClip.nium_internal::$collection.registerGroup( this, value ) ? value : null;  }
		private var _group:String;
		
		/**
		 * <span lang="ja">子ディスプレイオブジェクトが保存されている配列です。
		 * インデックス値が断続的に指定可能であるため、getChildAt() ではなくこのプロパティを使用して子ディスプレイオブジェクト走査を行います。
		 * この配列を操作することで元の配列を変更することはできません。</span>
		 * <span lang="en">The array that saves child display objects.
		 * Because the index value can specify intermittently, it scans the child display object by not using getChildAt() but using this property.
		 * It can not change the original array by operating this array.</span>
		 */
		public function get children():Array { return _children.slice(); }
		private var _children:Array;
		
		/**
		 * <span lang="ja"></span>
		 * <span lang="en"></span>
		 */
		public function get useChildIndexer():Boolean { return _useChildIndexer; }
		private var _useChildIndexer:Boolean = true;
		
		/**
		 * <span lang="ja">startDrag() メソッドを使用したドラッグ処理を行っている最中かどうかを取得します。</span>
		 * <span lang="en">Returns if the drag process which uses startDrag() method is executing.</span>
		 * 
		 * @see #startDrag()
		 * @see #stopDrag()
		 */
		public function get isDragging():Boolean { return _isDragging; }
		private var _isDragging:Boolean = false;
		
		/**
		 * <span lang="ja">ムービークリップのタイムライン内で再生ヘッドの移動処理が行われているかどうかを取得します。</span>
		 * <span lang="en">Returns if the movement processing of the playback head is executing in the timeline of the MovieClip.</span>
		 * 
		 * @see #play()
		 * @see #stop()
		 * @see #switchAtPlaying()
		 * @see #gotoAndPlay()
		 * @see #gotoAndStop()
		 */
		public function get isPlaying():Boolean { return _isPlaying; }
		private var _isPlaying:Boolean = false;
		
		/**
		 * 子をキーとしてインデックス値を保持した Dictionary インスタンスを取得します。
		 */
		private var _childToIndex:Dictionary;
		
		/**
		 * パッケージ内からの呼び出しかどうかを取得します。
		 */
		private var _internallyCalled:Boolean = false;
		
		/**
		 * 初期化が完了しているかどうかを取得します。
		 */
		private var _initialized:Boolean = false;
		
		
		
		
		
		/**
		 * <span lang="ja">新しい ExMovieClip インスタンスを作成します。</span>
		 * <span lang="en">Creates a new ExMovieClip object.</span>
		 * 
		 * @param initObject
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en"></span>
		 */
		public function ExMovieClip( initObject:Object = null ) {
			// クラスをコンパイルに含める
			nium_internal;
			
			// クラス名を取得する
			_classNameObj = ClassUtil.nium_internal::$getClassString( this );
			
			// 初期化する
			_children = [];
			_childToIndex = new Dictionary( true );
			
			// 親クラスを初期化する
			super();
			
			// コレクションに登録する
			ExMovieClip.nium_internal::$collection.addInstance( this );
			
			// ChildIndexer 機能の仕様可否
			_useChildIndexer = ChildIndexer.enabled;
			
			// 既存の子の数を取得する
			var l:int; l = super.numChildren;
			
			// 既存の子を登録する
			for ( var i:int = 0; i < l; i++ ) {
				var child:DisplayObject = super.getChildAt( i );
				_children.push( child );
				_childToIndex[child] = i;
			}
			
			// 初期化する
			ObjectUtil.setProperties( this, initObject );
			
			// 初期化を完了する
			_initialized = true;
			
			// 自動再生を開始する
			_play();
		}
		
		
		
		
		
		/**
		 * <span lang="ja">インスタンスに対して、複数のプロパティを一括設定します。</span>
		 * <span lang="en">Setup the several instance properties.</span>
		 * 
		 * @param parameters
		 * <span lang="ja">設定したいプロパティを含んだオブジェクトです。</span>
		 * <span lang="en">The object that contains the property to setup.</span>
		 * @return
		 * <span lang="ja">自身の参照です。</span>
		 * <span lang="en"></span>
		 */
		public function setProperties( parameters:Object ):DisplayObject {
			ObjectUtil.setProperties( this, parameters );
			return this;
		}
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスに子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function addChild( child:DisplayObject ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				var highest:DisplayObject = _children[_children.length - 1] as DisplayObject;
				return _addChildAt( child, highest ? _childToIndex[highest] + 1 : 0 );
			}
			
			return super.addChild( child );
		}
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the child is added. If you specify a currently occupied index position, the child object that exists at that position and all higher positions are moved up one position in the child list.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _addChildAt( child, index );
			}
			
			return super.addChildAt( child, index );
		}
		
		/**
		 * <span lang="ja">この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。</span>
		 * <span lang="en">Adds a child DisplayObject instance to this DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子として追加する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to add as a child of this DisplayObjectContainer instance.</span>
		 * @param index
		 * <span lang="ja">子を追加するインデックス位置です。</span>
		 * <span lang="en">The index position to which the child is added. If you specify a currently occupied index position, the child object that exists at that position and all higher positions are moved up one position in the child list.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		public function addChildAtAbove( child:DisplayObject, index:int ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _addChildAt( child, _getChildAt( index ) ? index + 1 : index );
			}
			
			return super.addChildAt( child, super.getChildAt( index ) ? index + 1 : index );
		}
		
		/**
		 * この DisplayObjectContainer インスタンスの指定されたインデックス位置に子 DisplayObject インスタンスを追加します。
		 */
		private function _addChildAt( child:DisplayObject, index:int ):DisplayObject {
			// 状態を変更する
			_internallyCalled = true;
			
			// 存在しなければ例外をスローする
			if ( !child ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_009 ).toString( "child" ) ); }
			
			// 既存の登録があれば
			if ( child.parent ) {
				// 対象の親が Loader であれば例外をスローする
				if ( child.parent is Loader ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_021 ).toString( this ) ); }
				
				// 登録を削除する
				child.parent.removeChild( child );
			}
			
			// 情報を取得する
			var highest:DisplayObject = _children[_children.length - 1] as DisplayObject;
			var virtualIndex:int = 0;
			var realIndex:int = 0;
			
			// 対象が存在しない、またはインデックスが最高値よりも大きければ
			if ( !highest || index > _childToIndex[highest] ) {
				realIndex = _children.length;
				_children.push( child );
				
				// 登録する
				_childToIndex[child] = index;
			}
			else {
				var children:Array = [];
				for ( var i:int = 0, l:int = _children.length; i < l; i++ ) {
					var target:DisplayObject = DisplayObject( _children[i] );
					virtualIndex = _childToIndex[target];
					
					if ( virtualIndex >= index ) {
						realIndex = i;
						children.push.apply( null, [ child ].concat( _children.slice( i ) ) );
						
						// 登録する
						_childToIndex[child] = index;
						break;
					}
					else {
						children.push( target );
					}
				}
				_children = children;
				
				for ( i = 0, l = _children.length; i < l; i++ ) {
					var target1:DisplayObject = _children[i + 0] as DisplayObject;
					var target2:DisplayObject = _children[i + 1] as DisplayObject;
					var virtual1:int = _childToIndex[target1];
					var virtual2:int = _childToIndex[target2];
					
					if ( virtual1 == virtual2 ) {
						_childToIndex[target2] += 1;
					}
				}
			}
			
			// イベントリスナーを登録する
			child.addEventListener( Event.REMOVED, _removed, false, int.MAX_VALUE );
			
			// 表示リストに追加する
			super.addChildAt( child, realIndex );
			
			// 状態を変更する
			_internallyCalled = false;
			
			return child;
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer インスタンスの子リストから指定の DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes the specified child DisplayObject instance from the child list of the DisplayObjectContainer instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">対象の DisplayObjectContainer インスタンスの子から削除する DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to remove.</span>
		 * @return
		 * <span lang="en">child パラメータで渡す DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that you pass in the child parameter.</span>
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _removeChild( child );
			}
			
			return super.removeChild( child );
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer の子リストの指定されたインデックス位置から子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Removes a child DisplayObject from the specified index position in the child list of the DisplayObjectContainer.</span>
		 * 
		 * @param index
		 * <span lang="ja">削除する DisplayObject の子インデックスです。</span>
		 * <span lang="en">The child index of the DisplayObject to remove.</span>
		 * @return
		 * <span lang="ja">削除された DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance that was removed.</span>
		 */
		override public function removeChildAt( index:int ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _removeChild( _getChildAt( index ) );
			}
			
			return super.removeChildAt( index );
		}
		
		/**
		 * DisplayObjectContainer インスタンスの子リストから指定の DisplayObject インスタンスを削除します。
		 */
		private function _removeChild( child:DisplayObject ):DisplayObject {
			// 状態を変更する
			_internallyCalled = true;
			
			for ( var i:int = 0, l:int = _children.length; i < l; i++ ) {
				var child2:DisplayObject = _children[i] as DisplayObject;
				
				if ( child == child2 ) {
					_children.splice( i, 1 );
					delete _childToIndex[child];
					break;
				}
			}
			
			// イベントリスナーを解除する
			child.removeEventListener( Event.REMOVED, _removed );
			
			// 表示リストから削除する
			super.removeChild( child );
			
			// 状態を変更する
			_internallyCalled = false;
			
			return child;
		}
		
		/**
		 * <span lang="ja">DisplayObjectContainer に追加されている全ての子 DisplayObject インスタンスを削除します。</span>
		 * <span lang="en">Remove the whole child DisplayObject instance which added to the DisplayObjectContainer.</span>
		 */
		public function removeAllChildren():void {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				// 状態を変更する
				_internallyCalled = true;
				
				for ( var i:int = 0, l:int = _children.length; i < l; i++ ) {
					super.removeChild( _children[i] );
				}
				
				// 子の登録を破棄する
				_children = [];
				_childToIndex = new Dictionary( true );
				
				// 状態を変更する
				_internallyCalled = false;
			}
			else {
				while ( super.numChildren > 0 ) {
					super.removeChildAt( 0 );
				}
			}
		}
		
		/**
		 * <span lang="ja">指定のインデックス位置にある子表示オブジェクトオブジェクトを返します。</span>
		 * <span lang="en">Returns the child display object instance that exists at the specified index.</span>
		 * 
		 * @param index
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child object.</span>
		 * @return
		 * <span lang="ja">指定されたインデックス位置にある子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child display object at the specified index position.</span>
		 */
		override public function getChildAt( index:int ):DisplayObject {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _getChildAt( index );
			}
			
			return super.getChildAt( index );
		}
		
		/**
		 * 指定のインデックス位置にある子表示オブジェクトオブジェクトを返します。
		 */
		private function _getChildAt( index:int ):DisplayObject {
			if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			
			for ( var i:int = 0, l:int = _children.length; i < l; i++ ) {
				var child:DisplayObject = DisplayObject( _children[i] );
				if ( index == _childToIndex[child] ) { return child; }
			}
			
			return null;
		}
		
		/**
		 * <span lang="ja">子 DisplayObject インスタンスのインデックス位置を返します。</span>
		 * <span lang="en">Returns the index position of a child DisplayObject instance.</span>
		 * 
		 * @param child
		 * <span lang="ja">特定する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The DisplayObject instance to identify.</span>
		 * @return
		 * <span lang="ja">特定する子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the child display object to identify.</span>
		 */
		override public function getChildIndex( child:DisplayObject ):int {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				return _getChildIndex( child );
			}
			
			return super.getChildIndex( child );
		}
		
		/**
		 * 子 DisplayObject インスタンスのインデックス位置を返します。
		 */
		private function _getChildIndex( child:DisplayObject ):int {
			if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
			if ( _childToIndex[child] == null ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_011 ).toString( "DisplayObject" ) ); }
			
			return _childToIndex[child];
		}
		
		/**
		 * <span lang="ja">表示オブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing child in the display object container.</span>
		 * 
		 * @param child
		 * <span lang="ja">インデックス番号を変更する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child DisplayObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child display object.</span>
		 */
		override public function setChildIndex( child:DisplayObject, index:int ):void {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				_setChildIndex( child, index );
			}
			else {
				super.setChildIndex( child, index );
			}
		}
		
		/**
		 * <span lang="ja">表示オブジェクトコンテナの既存の子の位置を変更します。</span>
		 * <span lang="en">Changes the position of an existing child in the display object container.</span>
		 * 
		 * @param child
		 * <span lang="ja">インデックス番号を変更する子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The child DisplayObject instance for which you want to change the index number.</span>
		 * @param index
		 * <span lang="en">child インスタンスの結果のインデックス番号です。</span>
		 * <span lang="en">The resulting index number for the child display object.</span>
		 */
		public function setChildIndexAbove( child:DisplayObject, index:int ):void {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				_setChildIndex( child, _getChildAt( index ) ? index + 1 : index );
			}
			else {
				super.setChildIndex( child, super.getChildAt( index ) ? index + 1 : index );
			}
		}
		
		/**
		 * 表示オブジェクトコンテナの既存の子の位置を変更します。
		 */
		private function _setChildIndex( child:DisplayObject, index:int ):void {
			var realIndex1:int = super.getChildIndex( child );
			var vertualIndex1:int = _childToIndex[child];
			var child2:DisplayObject = child;
			var ascending:Boolean = vertualIndex1 < index;
			
			// 操作範囲を取得する
			var children:Array = [];
			switch ( true ) {
				case vertualIndex1 > index	: {
					for ( var i:int = 0, l:int = realIndex1; i <= l; i++ ) {
						child2 = super.getChildAt( i );
						if ( index <= _childToIndex[child2] ) { break; }
					}
					break;
				}
				case vertualIndex1 == index	: { return; }
				case vertualIndex1 < index	: {
					for ( i = realIndex1, l = super.numChildren; i < l; i++ ) {
						var target:DisplayObject = super.getChildAt( i );
						if ( _childToIndex[target] <= index ) {
							child2 = target;
						}
					}
					break;
				}
			}
			
			// 位置を変更する
			super.setChildIndex( child, super.getChildIndex( child2 ) );
			_childToIndex[child] = index;
			
			// この配列を再構成する
			_updateChildren();
			
			children = _children.slice();
			
			if ( ascending ) {
				children.reverse();
			}
			
			// 仮想インデックスを再構成する
			var previousIndex:int = -1;
			for ( i = 0, l = children.length; i < l; i++ ) {
				child = children[i];
				if ( previousIndex == _childToIndex[child] ) {
					_childToIndex[child] -= ascending ? 1 : -1;
				}
				previousIndex = _childToIndex[child];
			}
		}
		
		/**
		 * <span lang="ja">指定された 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the two specified child objects.</span>
		 * 
		 * @param child1
		 * <span lang="ja">先頭の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The first child object.</span>
		 * @param child2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスです。</span>
		 * <span lang="en">The second child object.</span>
		 */
		override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				_swapChildrenAt( _getChildIndex( child1 ), _getChildIndex( child2 ) );
			}
			else {
				super.swapChildren( child1, child2 );
			}
		}
		
		/**
		 * <span lang="ja">子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。</span>
		 * <span lang="en">Swaps the z-order (front-to-back order) of the child objects at the two specified index positions in the child list.</span>
		 * 
		 * @param index1
		 * <span lang="ja">最初の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the first child object.</span>
		 * @param index2
		 * <span lang="ja">2 番目の子 DisplayObject インスタンスのインデックス位置です。</span>
		 * <span lang="en">The index position of the second child object.</span>
		 */
		override public function swapChildrenAt( index1:int, index2:int ):void {
			if ( _useChildIndexer ) {
				if ( !_initialized ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_024 ).toString( toString() ) ); }
				
				_swapChildrenAt( index1, index2 );
			}
			else {
				super.swapChildrenAt( index1, index2 );
			}
		}
		
		/**
		 * 子リスト内の指定されたインデックス位置に該当する 2 つの子オブジェクトの z 順序（重ね順）を入れ替えます。
		 */
		private function _swapChildrenAt( index1:int, index2:int ):void {
			// 子を取得する
			var child1:DisplayObject = _getChildAt( index1 );
			var child2:DisplayObject = _getChildAt( index2 );
			
			// 対象が子として登録されていなければ例外をスローする
			if ( !child1 || !child2 ) { throw new Error( Logger.getLog( L10NNiumMsg.getInstance().ERROR_004 ).toString() ); }
			
			// インデックスの数値によって入れ替える
			if ( index1 < index2 ) {
				var tmpChild:DisplayObject = child1;
				var tmpIndex:int = index1;
				child1 = child2;
				child2 = tmpChild;
				index1 = index2;
				index2 = tmpIndex;
			}
			
			// 子の位置を移動する
			super.swapChildren( child1, child2 );
			_childToIndex[child1] = index2;
			_childToIndex[child2] = index1;
			
			// この配列を再構成する
			_updateChildren();
		}
		
		/**
		 * 子の登録を更新します。
		 */
		private function _updateChildren():void {
			_children = [];
			for ( var i:int = 0, l:int = super.numChildren; i < l; i++ ) {
				_children.push( super.getChildAt( i ) );
			}
		}
		
		/**
		 * <span lang="ja">ムービークリップのタイムライン内で再生ヘッドを移動します。</span>
		 * <span lang="en">Moves the playback head in the timeline of the MovieClip.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function play():void {
			_play();
		}
		
		/**
		 * ムービークリップのタイムライン内で再生ヘッドを移動します。
		 */
		private function _play():void {
			_isPlaying = Boolean( super.totalFrames > 1 );
			super.play();
		}
		
		/**
		 * <span lang="ja">ムービークリップ内の再生ヘッドを停止します。</span>
		 * <span lang="en">Stops the playback head in the MovieClip.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function stop():void {
			_stop();
		}
		
		/**
		 * ムービークリップ内の再生ヘッドを停止します。
		 */
		private function _stop():void {
			_isPlaying = false;
			super.stop();
		}
		
		/**
		 * <span lang="ja">ムービークリップの再生状態に応じて、再生もしくは停止します。</span>
		 * <span lang="en">Playback or stops according to the playback state of the MovieClip.</span>
		 * 
		 * @see #isPlaying
		 */
		public function switchAtPlaying():void {
			if ( _isPlaying ) {
				_play();
			}
			else {
				_stop();
			}
		}
		
		/**
		 * <span lang="ja">指定されたフレームで SWF ファイルの再生を開始します。</span>
		 * <span lang="en">Start the playback of the SWF file with the specified frame.</span>
		 * 
		 * @param frame
		 * <span lang="ja">再生ヘッドの送り先となるフレーム番号を表す数値、または再生ヘッドの送り先となるフレームのラベルを表すストリングです。数値を指定する場合は、指定するシーンに対する相対数で指定します。シーンを指定しない場合は、再生するグローバルフレーム番号を決定するのに現在のシーンが関連付けられます。シーンを指定した場合、再生ヘッドは指定されたシーン内のフレーム番号にジャンプします。</span>
		 * <span lang="en">The frame number or the frame name to move the playback head. When specify by frame count, specify the relative number to the specified scene. When do not specify the scene, the current scene will relate to decide the grobal frame number to playback. When specify the scene, the plyback head will jump to the frame number in specified scene.</span>
		 * @param scenes
		 * <span lang="ja">再生するシーンの名前です。このパラメータはオプションです。</span>
		 * <span lang="en">The name of the scene to playback. This parameter is optinal.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function gotoAndPlay( frame:Object, scenes:String = null ):void {
			_isPlaying = Boolean( super.totalFrames > 1 );
			super.gotoAndPlay( frame, scenes );
		}
		
		/**
		 * <span lang="ja">このムービークリップの指定されたフレームに再生ヘッドを送り、そこで停止させます。</span>
		 * <span lang="en">Set the palyback head to the specified frame of the MovieClip and stop at that point.</span>
		 * 
		 * @param frame
		 * <span lang="ja">再生ヘッドの送り先となるフレーム番号を表す数値、または再生ヘッドの送り先となるフレームのラベルを表すストリングです。数値を指定する場合は、指定するシーンに対する相対数で指定します。シーンを指定しない場合は、送り先のグローバルフレーム番号を決定するのに現在のシーンが関連付けられます。シーンを指定した場合、再生ヘッドは指定されたシーン内のフレーム番号に送られて停止します。</span>
		 * <span lang="en">The frame number or the frame name to move the playback head. When specify by frame count, specify the relative number to the specified scene. When do not specify the scene, the current scene will relate to decide the grobal frame number to playback. When specify the scene, the plyback head will jump to the frame number in specified scene.</span>
		 * @param scenes
		 * <span lang="ja">シーン名です。このパラメータはオプションです。</span>
		 * <span lang="en">The name of the scene to playback. This parameter is optinal.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function gotoAndStop( frame:Object, scenes:String = null ):void {
			_isPlaying = false;
			super.gotoAndStop( frame, scenes );
		}
		
		/**
		 * <span lang="ja">次のフレームに再生ヘッドを送り、停止します。</span>
		 * <span lang="en">Move the playback head to the next frame and stop at that point.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function nextFrame():void {
			_isPlaying = false;
			super.nextFrame();
		}
		
		/**
		 * <span lang="ja">直前のフレームに再生ヘッドを戻し、停止します。</span>
		 * <span lang="en">Move the playback head to the previous frame and stop at that point.</span>
		 * 
		 * @see #isPlaying
		 */
		override public function prevFrame():void {
			_isPlaying = false;
			super.prevFrame();
		}
		
		/**
		 * <span lang="ja">指定されたスプライトをユーザーがドラッグできるようにします。</span>
		 * <span lang="en">Allow the user to drag the specified sprite.</span>
		 * 
		 * @param lockCenter
		 * <span lang="ja">ドラッグ可能なスプライトが、マウス位置の中心にロックされるか (true)、ユーザーがスプライト上で最初にクリックした点にロックされるか (false) を指定します。</span>
		 * <span lang="en">Specify the sprite which will be able to drag locks at the center of the mouse position(true) or the first point that the user clicked on the sprite(false).</span>
		 * @param bounds
		 * <span lang="en">Sprite の制限矩形を指定する Sprite の親の座標を基準にした相対値です。</span>
		 * <span lang="en">Specify the limitation rectangle of the sprite. It is a relative value based on parents' coordinates of the sprite.</span>
		 * 
		 * @see #isDragging
		 */
		override public function startDrag( lockCenter:Boolean = false, bounds:Rectangle = null ):void {
			_isDragging = true;
			super.startDrag( lockCenter, bounds );
		}
		
		/**
		 * <span lang="ja">startDrag() メソッドを終了します。</span>
		 * <span lang="en">Ends the startDrag() method.</span>
		 * 
		 * @see #isDragging
		 */
		override public function stopDrag():void {
			_isDragging = false;
			super.stopDrag();
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
			if ( _classNameObj ) { return ObjectUtil.formatToString( this, _classNameObj.toString(), _id ? "id" : null ); }
			return super.toString();
		}
		
		
		
		
		
		/**
		 * 表示オブジェクトが表示リストから削除されようとしているときに送出されます。
		 */
		private function _removed( e:Event ):void {
			// 内部処理であれば終了する
			if ( _internallyCalled ) { return; }
			
			// 自身で発生したイベントでなければ終了する
			if ( e.eventPhase != EventPhase.AT_TARGET ) { return; }
			
			var child1:DisplayObject = e.target as DisplayObject;
			
			if ( !child1 ) { return; }
			
			for ( var i:int = 0, l:int = _children.length; i < l; i++ ) {
				var child2:DisplayObject = _children[i] as DisplayObject;
				
				if ( child1 == child2 ) {
					_children.splice( i, 1 );
					delete _childToIndex[child1];
					break;
				}
			}
			
			// イベントリスナーを解除する
			child1.removeEventListener( Event.REMOVED, _removed );
		}
	}
}
