// ignore_for_file: constant_identifier_names

// IO
const PHOTO_ICON_REL_SIZE = 0.5;
const PHOTO_ICON_OPACITY = 0.3;
const CHALLENGE_IMAGE_REL_HEIGHT = 0.5;
const PROMPT_PLACEHOLDER = 'loading...';
const GUESSES_WORD_PLACEHOLDER = '???';

// classifier
const CLASSIFIER_PATH = 'assets/models/ConvNeXt_nano.pt';
const LABELS_PATH = 'assets/labels/imagenet1k_labels.txt';
const IMAGE_SIZE = 224;
const CLASSIFIER_MEAN = [0.485, 0.456, 0.406];
const CLASSIFIER_STD = [0.229, 0.224, 0.225];
const TOP_K_PREDICTIONS = 5;

// paths
const TEMP_IMAGE_FNAME = 'possible_image.jpg';
const CHALLENGE_HISTORY_FNAME = 'history.csv';
const TIMER_HISTORY_FNAME = 'timer.json';
const PROMPT_FNAME = 'prompt.txt';
const IMAGES_PATH = 'images';

// timer
const PROMPT_TIMER = "prompt_timer";
const SEND_TIMER = "send_timer";
const TIMER_CALLBACK_EVERY = 1;
const TIMER_DURATION_AFTER_FAIL = 20 * 60;

// other
const CSV_FIELD_DELIMITER = ';';
