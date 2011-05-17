import flash.ui.ContextMenu;
import jp.progression.ui.IContextMenuBuilder;

/**
 * <span lang="ja">このオブジェクトに関連付けられたコンテキストメニューを指定します。</span>
 * <span lang="en">Specifies the context menu associated with this object.</span>
 */
override public function get contextMenu():ContextMenu { return _contextMenu; }
override public function set contextMenu( value:ContextMenu ):void {
	if ( _allowBuildContextMenu ) {
		super.contextMenu = value;
	}
	else {
		_contextMenu = value;
		
		// すでに存在していれば
		if ( super.contextMenu && PackageInfo.managerClassRef ) {
			// コンテクストメニューを再構築する
			_contextMenuBuilder = PackageInfo.managerClassRef.config.contextMenuBuilder;
		}
	}
}

private function get _contextMenuBuilder():Class { return __contextMenuBuilder; }
private function set _contextMenuBuilder( value:Class ):void {
	_allowBuildContextMenu = true;
	
	if ( ___contextMenuBuilder ) {
		___contextMenuBuilder.dispose();
		___contextMenuBuilder = null;
	}
	
	__contextMenuBuilder = value;
	
	if ( __contextMenuBuilder ) {
		___contextMenuBuilder = new __contextMenuBuilder( this );
	}
	
	_allowBuildContextMenu = false;
}

private var _contextMenu:ContextMenu;
private var __contextMenuBuilder:Class;
private var ___contextMenuBuilder:IContextMenuBuilder;
private var _allowBuildContextMenu:Boolean = false;
