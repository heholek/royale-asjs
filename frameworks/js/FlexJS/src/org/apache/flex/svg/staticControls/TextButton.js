/**
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

goog.provide('org.apache.flex.svg.staticControls.TextButton');

goog.require('org.apache.flex.core.UIBase');



/**
 * @constructor
 * @extends {org.apache.flex.core.UIBase}
 */
org.apache.flex.svg.staticControls.TextButton = function() {
  goog.base(this);
};
goog.inherits(org.apache.flex.svg.staticControls.TextButton,
    org.apache.flex.core.UIBase);


/**
 * Metadata
 *
 * @type {Object.<string, Array.<Object>>}
 */
org.apache.flex.svg.staticControls.TextButton.prototype.FLEXJS_CLASS_INFO =
    { names: [{ name: 'TextButton',
                qName: 'org.apache.flex.svg.staticControls.TextButton'}] };


/**
 * @override
 */
org.apache.flex.svg.staticControls.TextButton.prototype.createElement =
    function() {
  this.element = document.createElement('embed');
  this.element.setAttribute('src', 'org/apache/flex/svg/staticControls/assets/TextButton_Skin.svg');

  this.positioner = this.element;

  return this.element;
};


/**
 * @override
 */
org.apache.flex.svg.staticControls.TextButton.prototype.finalizeElement =
    function() {
  var listenersArray;
  if (goog.events.hasListener(this.element, goog.events.EventType.CLICK)) {
    listenersArray = goog.events.getListeners(this.element, goog.events.EventType.CLICK, false);

    /* As we are assigning an actual function object instead of just the name,
       make sure to use a unique name ('clickHandler') instead of a native 
       name, like 'click' or 'onclick'. 
       
       Note: use array notation for property assignment so the compiler doesn't
             rename the property ;-) 
    */
    this.element['clickHandler'] = listenersArray[0].listener;
  }
};


/**
 * @expose
 * @return {string} The text getter.
 */
org.apache.flex.svg.staticControls.TextButton.prototype.get_text =
    function() {
  return this.element.getAttribute('label');
};


/**
 * @expose
 * @param {string} value The text setter.
 */
org.apache.flex.svg.staticControls.TextButton.prototype.set_text =
    function(value) {
  this.element.setAttribute('label', value);
};
