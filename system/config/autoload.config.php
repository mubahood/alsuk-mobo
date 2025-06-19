<?php

use JetBrains\PhpStorm\NoReturn;

include_once(SYSTEM_PATH."config/routes.php");
include_once ("autoload.php");
include_once ("database.config.php");

//Loading smarty templating engine
const SYS_DIR = "views/smarty-3.1.34/libs/";
//die();
require_once (APP_PATH.SYS_DIR."Smarty.class.php");


foreach ($inputs as $file_path => $input_class) {
    include_once($file_path . ".php");
}

class Controller {
    public Smarty $smarty; //Smarty class

    public $load; //Load class

    public Input $input; //Input class

    public Server $server; //Server class

    public Cookies $cookie; //Cookie class

    public Session $session; //Session class

    public Mail $mail; //mail class

    public stdClass|array $model = [];

    public stdClass|array $library = [];

    public stdClass|array $helper = [];

    public stdClass|array $controller = [];

    function __construct() {
        //parent::__construct();
        //Loading smarty
        $smarty = new Smarty();
        $smarty->setTemplateDir(APP_PATH.'views/templates')
            ->setCompileDir(APP_PATH.'views/templates_c')
            ->setCacheDir(APP_PATH.'views/cache');
        $this->smarty = $smarty;

        //Loading models

        //Input class
        $this->input = new Input();
        //Server class
        $this->server = new Server();
        //cookie class
        $this->cookie = new Cookies();
        //Session class
        $this->session = new Session();
        //Mail class
        $this->mail = new Mail();

        $this->helper = new stdClass();
        $this->model = new stdClass();
        $this->library = new stdClass();
        $this->controller = new stdClass();
    }

    function model($class) {
        include_once(APP_PATH."models/" . $class . ".php");
        if (class_exists($class, true))
            $this->model->$class = new $class;
    }


    #[NoReturn] function redirect($url) {
        header("location:".$url);
        exit;
    }

    #[NoReturn] function controller($class) {
        include_once(APP_PATH . "controllers/" . $class . ".php");
        if (class_exists($class, true))
            $this->controller->$class = new $class;
    }

    function class_load_error($error) {
        $smarty = $this->smarty();
        $smarty->assign("error", $error);
        $smarty->display("./error/error.tpl");
    }

    function remove_none_utf_char($string): array|string|null
    {
        $utf8 = array(
            '/[áàâãªä]/u'   =>   'a',
            '/[ÁÀÂÃÄ]/u'    =>   'A',
            '/[ÍÌÎÏ]/u'     =>   'I',
            '/[íìîï]/u'     =>   'i',
            '/[éèêë]/u'     =>   'e',
            '/[ÉÈÊË]/u'     =>   'E',
            '/[óòôõºö]/u'   =>   'o',
            '/[ÓÒÔÕÖ]/u'    =>   'O',
            '/[úùûü]/u'     =>   'u',
            '/[ÚÙÛÜ]/u'     =>   'U',
            '/ç/'           =>   'c',
            '/Ç/'           =>   'C',
            '/ñ/'           =>   'n',
            '/Ñ/'           =>   'N',
            '/–/'           =>   '-', // UTF-8 hyphen to "normal" hyphen
            '/[’‘‹›‚]/u'    =>   ' ', // Literally a single quote
            '/[“”«»„]/u'    =>   ' ', // Double quote
            '/ /'           =>   ' ', // nonbreaking space (equiv. to 0x160)
        );
        return preg_replace(array_keys($utf8), array_values($utf8), $string);
    }

    function remove_special_chars($string): array|string|null
    {
        $string = strip_tags($string);
        $string = preg_replace('/[^A-Za-z0-9. -]/', ' ', $string);
        // Replace sequences of spaces with hyphen
        return preg_replace('/  */', '-', $string);
    }

    function xss_clean($string): string
    {
        return strip_tags($string);
    }

    function remove_numbers_from_string($string): array|string|null
    {
        return preg_replace('/\d+/u', '', $string);
    }

    function replace_multiple_spaces($string): array|string|null
    {
        return preg_replace('!\s+!', ' ', $string);
    }

}

class Model extends Controller {
    public MysqliDb $db;
    function __construct(){
        parent::__construct();
        //Db config
        global $database_config;
        $this->db = new MysqliDb($database_config['host'], $database_config['username'], $database_config['password'], $database_config['database']);
    }

    public function password_hash($string): bool|string
    {
        return hash('sha256', $string);
    }

    /**
     * @throws Exception
     */
    function check_url_for_duplicates($url, $table, $column) {
        $this->db->where($column,  $url);
        $this->db->orderBy($column, 'desc');

        $query = $this->db->get($table, null, array($column));
        if (empty($query))
            $url = $url;
        else{
            $url_string = explode("-", $url);
            $url_counter = end($url_string);
            if (is_numeric($url_counter))
                $url_counter++;
            else
                $url_counter = $url_counter."-1";
            array_pop($url_string);
            $url_string[] = $url_counter;
            $url = implode("-", $url_string);
            $url = $this->check_url_for_duplicates($url, $table, $column);
        }
        return $url;
    }

    function xss_clean($string) : string {
        /*
         * Return cleaned string
         */
        return filter_var(strip_tags($string), FILTER_SANITIZE_FULL_SPECIAL_CHARS);

    }

    function validate_email($email): bool
    {
        /*
        *
         * Remove all illegal characters from email
        */
        $email = filter_var($email, FILTER_SANITIZE_EMAIL);

        /*
         * Validate email
         */
        return ! filter_var($email, FILTER_VALIDATE_EMAIL) === false;
    }

    function validate_ip_address($ip): bool
    {
        return !filter_var($ip, FILTER_VALIDATE_IP) === false;
    }

    function validate_url($url) {
        $url = filter_var($url, FILTER_SANITIZE_URL);
        return filter_var($url, FILTER_VALIDATE_URL);
    }
}