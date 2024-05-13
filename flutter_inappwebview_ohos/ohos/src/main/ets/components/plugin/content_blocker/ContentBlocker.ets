import ContentBlockerAction from './ContentBlockerAction';
import ContentBlockerTrigger from './ContentBlockerTrigger';

export default class ContentBlocker {
  private trigger: ContentBlockerTrigger;
  private action: ContentBlockerAction;

  constructor(trigger: ContentBlockerTrigger, action: ContentBlockerAction) {
    this.trigger = trigger;
    this.action = action;
  }
}