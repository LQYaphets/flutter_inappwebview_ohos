import ISettings from '../ISettings';
import InAppBrowserActivity from './InAppBrowserActivity';

const LOG_TAG = "InAppBrowserSettings"

export default class InAppBrowserSettings implements ISettings<InAppBrowserActivity> {

  public hidden: boolean = false
  public hideToolbarTop: boolean = false
  public toolbarTopBackgroundColor: string | null = null
  public toolbarTopFixedTitle: string | null = null
  public hideUrlBar: boolean = false
  public hideProgressBar: boolean = false

  public hideTitleBar: boolean = false
  public closeOnCannotGoBack: boolean = true
  public allowGoBackWithBackButton: boolean = true
  public shouldCloseOnBackButtonPressed: boolean = false
  public hideDefaultMenuItems: boolean = false

  constructor() {}

  public parse(settings: Map<string, ESObject>): InAppBrowserSettings {
    let keys = settings.keys()
    for(let key of keys) {
      if(settings[key] == null) {
        continue
      }

      switch (key) {
        case "hidden":
          this.hidden = settings[key] as boolean;
          break;
        case "hideToolbarTop":
          this.hideToolbarTop = settings[key] as boolean;
          break;
        case "toolbarTopBackgroundColor":
          this.toolbarTopBackgroundColor = settings[key] as string;
          break;
        case "toolbarTopFixedTitle":
          this.toolbarTopFixedTitle = settings[key] as string;
          break;
        case "hideUrlBar":
          this.hideUrlBar = settings[key] as boolean;
          break;
        case "hideTitleBar":
          this.hideTitleBar = settings[key] as boolean;
          break;
        case "closeOnCannotGoBack":
          this.closeOnCannotGoBack = settings[key] as boolean;
          break;
        case "hideProgressBar":
          this.hideProgressBar = settings[key] as boolean;
          break;
        case "allowGoBackWithBackButton":
          this.allowGoBackWithBackButton = settings[key] as boolean;
          break;
        case "shouldCloseOnBackButtonPressed":
          this.shouldCloseOnBackButtonPressed = settings[key] as boolean;
          break;
        case "hideDefaultMenuItems":
          this.hideDefaultMenuItems = settings[key] as boolean;
          break;
      }
    }

    return this
  }

  public toMap(): Map<string, ESObject> {
    let settings: Map<string, ESObject> = new Map<string, ESObject>()
    settings.set("hidden", this.hidden);
    settings.set("hideToolbarTop", this.hideToolbarTop);
    settings.set("toolbarTopBackgroundColor", this.toolbarTopBackgroundColor);
    settings.set("toolbarTopFixedTitle", this.toolbarTopFixedTitle);
    settings.set("hideUrlBar", this.hideUrlBar);
    settings.set("hideTitleBar", this.hideTitleBar);
    settings.set("closeOnCannotGoBack", this.closeOnCannotGoBack);
    settings.set("hideProgressBar", this.hideProgressBar);
    settings.set("allowGoBackWithBackButton", this.allowGoBackWithBackButton);
    settings.set("shouldCloseOnBackButtonPressed", this.shouldCloseOnBackButtonPressed);
    settings.set("hideDefaultMenuItems", this.hideDefaultMenuItems);
    return settings;
  }

  public getRealSettings(inAppBrowserActivity: InAppBrowserActivity): Map<string, ESObject> {
    let realSettings: Map<string, ESObject> = this.toMap()
    realSettings.set("hidden", inAppBrowserActivity.isHidden);
    // realSettings.set("hideToolbarTop", inAppBrowserActivity.actionBar == null || !inAppBrowserActivity.actionBar.isShowing());
    // realSettings.set("hideUrlBar", inAppBrowserActivity.menu == null || !inAppBrowserActivity.menu.findItem(R.id.menu_search).isVisible());
    // realSettings.set("hideProgressBar", inAppBrowserActivity.progressBar == null || inAppBrowserActivity.progressBar.getMax() == 0);
    return realSettings;
  }
}