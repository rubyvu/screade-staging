// Import libs from node modules
import 'bootstrap';
import jQuery from 'jquery';
import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';
import 'select2';
import Marquee3k from 'marquee3000';
import 'bootstrap-datepicker';
import 'timepicker/jquery.timepicker.js';
import 'jquery-ui/ui/widgets/tabs';
import videojs from 'video.js';

// Import internal scripts
import './shared/chat/chats';
import './shared/chat/chat_messages';
import './shared/chat/chat_twilio';
import './shared/chat/recorder';
import './shared/events';
import './shared/font_customizer';
import './shared/global-search';
import './shared/groups';
import './shared/image_viewer';
import './shared/local_date';
import './shared/maps';
import './shared/modals';
import './shared/multilevel_dropdown';
import './shared/news_articles';
import './shared/notifications';
import './shared/posts';
import './shared/streams';
import './shared/user_asset';
import './shared/video_player';
import  { isTwelveHoursFormat } from './shared/location';
