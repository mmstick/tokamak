TokamakView = require './tokamak-view'
CargoView = require './cargo-view'
MultirustToolchainView = require './multirust-toolchain-view'
{CompositeDisposable} = require 'atom'

module.exports = Tokamak =
  # Config schema
  config:
    rustcBinPath:
      title: 'Path to the Rust compiler'
      type: 'string'
      default: '/usr/local/bin/rustc'
      order: 1
    cargoBinPath:
      title: 'Path to the Cargo package manager'
      type: 'string'
      default: '/usr/local/bin/cargo'
      order: 2
    multirustBinPath:
      title: 'Path to the Multirust rust installation manager'
      type: 'string'
      default: '/usr/local/bin/multirust'
      order: 3
    racerBinPath:
      title: 'Path to the Racer executable'
      type: 'string'
      default: '/usr/local/bin/racer'
      order: 4
    rustSrcPath:
      title: 'Path to the Rust source code directory'
      type: 'string'
      default: '/usr/local/src/rust/src/'
      order: 5
    cargoHome:
      title: 'Cargo home directory (optional)'
      type: 'string'
      description: 'Needed when providing completions for Cargo crates when Cargo is installed in a non-standard location.'
      default: ''
      order: 6
    autocompleteBlacklist:
      title: 'Autocomplete Scope Blacklist'
      description: 'Autocomplete suggestions will not be shown when the cursor is inside the following comma-delimited scope(s).'
      type: 'string'
      default: '.source.go .comment'
      order: 7
    show:
      title: 'Show position for editor with definition'
      description: 'Choose one: Right, or New. If your view is vertically split, choosing Right will open the definition in the rightmost pane.'
      type: 'string'
      default: 'New'
      enum: ['Right', 'New']
      order: 8

    #TODO: Write autodetection of toolchain

  tokamakView: null
  cargoView: null
  multirustToolchainView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @tokamakView = new TokamakView(state.tokamakViewState)
    @cargoView = new CargoView(state.cargoViewState)
    @multirustToolchainView = new MultirustToolchainView(state.multirustToolchainViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @tokamakView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'tokamak:toggle': => @toggle()

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'tokamak'

    @toolBar.addSpacer()

    @toolBar.addButton
      icon: 'tools'
      callback: 'tokamak:multirust-select-toolchain'
      tooltip: 'Change Rust Toolchain'

    @toolBar.onDidDestroy ->
      @toolBar = null

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @multirustToolchainView.destroy()
    @cargoView.destroy()
    @tokamakView.destroy()
    @toolBar?.removeItems()

  serialize: ->
    tokamakViewState: @tokamakView.serialize()
    cargoViewState: @cargoView.serialize()
    multirustToolchainViewState: @multirustToolchainView.serialize()

  toggle: ->
    console.log 'Tokamak was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()


  createCargoBinary: ->
    console.log 'Creating Cargo binary project!'

  createCargoLib: ->
    console.log 'Creating Cargo library project!'