//
//  Definitions.h
//  Vkmsg
//
//  Created by Igor Khomenko on 3/21/12.
//  Copyright (c) 2012 Injoit. All rights reserved.
//

#define VK @"http://vk.com"

#define CLIENT_ID @"2851370"
#define CLIENT_SECRET @"UZjl7iOksJMILkmu4dPi"


#define kUserId @"user_id"
#define kUid @"uid"
#define kAccessToken @"access_token"
#define kSecret @"secret"
#define kResponse @"response"
#define kPhotoSrcSmall @"photo_src_small"
#define kServer @"server"
#define kHash @"hash"
#define kPhoto @"photo"
#define kVideo @"video"
#define kAudio @"audio"
#define kDoc @"doc"
#define kGeo @"geo"
#define kUploadUrl @"upload_url"
#define kContacts @"contacts"
#define kPhone @"phone"
#define kType @"type"
#define kId @"id"
#define kSrc @"src"
#define kSrcBig @"src_big"
#define kSrcXXXBig @"src_xxxbig"
#define kImage @"image"
#define kOwnerId @"owner_id"
#define kVid @"vid"
#define kDuration @"duration"
#define kArtist @"artist"
#define kTitle @"title"
#define kUrl @"url"
#define kPoint @"point"
#define kCoordinates @"coordinates"
#define kBody @"body"
#define kDate @"date"


// methods names
//
// User Sign In/Sign Up
#define vkAPIMethodNameAuthSignUp @"auth.signup"
#define vkAPIMethodNameAuthConfirm @"auth.confirm"
#define vkAPIMethodNameAuthCheckPhone @"auth.checkPhone"
//
// Users profile
#define vkAPIMethodNameUsersGet @"users.get"
//
// Update photo
#define vkAPIMethodPhotosGetProfileUploadServer @"photos.getProfileUploadServer"
#define vkAPIMethodPhotosSaveProfilePhoto @"photos.saveProfilePhoto"
#define vkAPIMethodPhotosSaveMessagePhoto @"photos.saveMessagesPhoto"
//
// Get Dialogs
#define vkAPIMethodMessagesGetDialog @"messages.getDialogs"
#define vkAPIMethodMessagesDeleteDialog @"messages.deleteDialog"
//
// Push notifications
#define vkAPIMethodDisablePushNotifications @"account.unregisterDevice"
#define vkAPIMethodEnablePushNotifications @"account.registerDevice"
#define vkAPIMethodSetSilenceMode @"account.setSilenceMode"
//
// Friedns
#define vkAPIMethodNameFriendsGet @"friends.get"
#define vkAPIMethodNameFriendsAdd @"friends.add"
#define vkAPIMethodNameFriendsDelete @"friends.delete"
#define vkAPIMethodNameFriendsGetSuggestions @"friends.getSuggestions"
#define vkAPIMethodNameAccountImportContacts @"account.importContacts"
#define vkAPIMethodNameFriendsGetByPhones @"friends.getByPhones"
#define vkAPIMethodNameFriendsGetRequests @"friends.getRequests"
#define vkAPIMethodNameFriendsDeleteAllRequests @"friends.deleteAllRequests"
#define vkAPIMethodNameFriendsGetLists @"friends.getLists"
#define vkAPIMethodNameFriendsAddList @"friends.addList"
#define vkAPIMethodNameFriendsEditList @"friends.editList"
#define vkAPIMethodNameFriendsGetMutual @"friends.getMutual"
#define vkAPIMethodNameFriendsGetOnline @"friends.getOnline"
#define vkAPIMethodNameFriendsGetAppUsers @"friends.getAppUsers"
//
// Execute
#define vkAPIMethodNameExecute @"execute"
//
// Messages
#define vkAPIMethodNameMessagesGetDialogs @"messages.getDialogs" //возвращает список диалогов текущего пользователя.
#define vkAPIMethodNameMessagesGetHistory @"messages.getHistory" //возвращает историю сообщений для данного пользователя.

#define vkAPIMethodNameMessagesGetById @"messages.getById" //возвращает сообщения по их ID.
#define vkAPIMethodNameMessagesGet @"messages.get" //возвращает список входящих либо исходящих сообщений текущего пользователя.
#define vkAPIMethodNameMessagesSearchDialogs @"messages.searchDialogs" //возвращает список диалогов и бесед пользователя по поисковому запросу.
#define vkAPIMethodNameMessagesSearch @"messages.search" //возвращает найденные сообщения текущего пользователя по введенной строке поиска.
#define vkAPIMethodNameMessagesGetUploadServer @"photos.getMessagesUploadServer"
#define vkAPIMethodNameMessagesSend @"messages.send" //посылает сообщение.
#define vkAPIMethodNameMessagesDelete @"messages.delete" //удаляет сообщение.
#define vkAPIMethodNameMessagesDeleteDialog @"messages.deleteDialog" //Удаляет все сообщения в диалоге,
#define vkAPIMethodNameMessagesRestore @"messages.restore" //восстанавливает только что удаленное сообщение.
#define vkAPIMethodNameMessagesMarkAsNew @"messages.markAsNew" //помечает сообщения как непрочитанные.
#define vkAPIMethodNameMessagesMarkAsRead @"messages.markAsRead" //помечает сообщения как прочитанные.
#define vkAPIMethodNameMessagesSetActivity @"messages.setActivity" //изменяет статус набора текста пользователем в диалоге.
#define vkAPIMethodNameMessagesGetLastActivity @"messages.getLastActivity" //возвращает текущий статус и время последней активности пользователя.
#define vkAPIMethodNameMessagesCreateChat @"messages.createChat" //создаёт беседу с несколькими участниками.
#define vkAPIMethodNameMessagesEditChat @"messages.editChat" //изменяет название беседы.
#define vkAPIMethodNameMessagesGetChatUsers @"messages.getChatUsers" //получает список участников беседы.
#define vkAPIMethodNameMessagesAddChatUser @"messages.addChatUser" //добавляет в беседу нового участника.
#define vkAPIMethodNameMessagesRemoveChatUser @"messages.removeChatUser" //исключает участника из беседы.
#define vkAPIMethodNameMessagesGetLongPollServer @"messages.getLongPollServer" //возвращает данные, необходимые для подключения к LongPoll серверу


// methods type
typedef enum {
    // User Sign In/Sign Up
    VKQueriesTypesAuthSignIn,
    VKQueriesTypesAuthSignUp,
    VKQueriesTypesAuthConfirm,
    VKQueriesTypesAuthCheckPhone,
    //
    // Users profile
    VKQueriesTypesUsersGet,
    //
    // Update photo
    VKQueriesTypesPhotoGetUrl,
    VKQueriesTypesUploadPhoto,
    VKQueriesTypesSavePhoto,
    //
    // Push Notifications
    VKQueriesTyperDisablePushNotifications,
    VKQueriesTyperEnablePushNotifications,
    VKQueriesTypesSetSilenceMode,
    //
    // Get Dialogs
    VKQueriesTyperMessagesGetDialogs,
	VKQueriesTypesMessagesDialogDelete,
    //
    // Friends
    VKQueriesTypesFriendsGet,
    VKQueriesTypesFriendsGetByList,
    VKQueriesTypesRequestsGet,
    VKQueriesTypesSuggestionsGet,
    VKQueriesTypesImportContacts,
    VKQueriesTypesFriendsAdd,
    VKQueriesTypesFriendsGetByPhones,
    VKQueriesTypesFriendsDelete,
    VKQueriesTypesFriendsGetSuggestions,
    VKQueriesTypesFriendsGetRequests,
    VKQueriesTypesFriendsGetLists,
    VKQueriesTypesFriendsAddList,
    VKQueriesTypesFriendsEditList,
    VKQueriesTypesFriendsGetMutual,
    VKQueriesTypesFriendsGetOnline,
    VKQueriesTypesFriendsGetAppUsers,
    //
    // Execute
    VKQueriesTypesExecute,
    //
    // Messages
    VKQueriesTypesMessagesGetDialogs,
    VKQueriesTypesMessagesGetHistory,
    VKQueriesTypesMessagesGetById,
    VKQueriesTypesMessagesGet,
    VKQueriesTypesMessagesSearchDialogs,
    VKQueriesTypesMessagesSearch,
    VKQueriesTypesMessagesSend,
    VKQueriesTypesMessagesDelete,
    VKQueriesTypesMessagesDeleteDialog,
    VKQueriesTypesMessagesRestore,
    VKQueriesTypesMessagesMarkAsNew,
    VKQueriesTypesMessagesMarkAsRead,
    VKQueriesTypesMessagesGetLastActivity,
    VKQueriesTypesMessagesSetActivity,
    VKQueriesTypesMessagesCreateChat,
    VKQueriesTypesMessagesEditChat,
    VKQueriesTypesMessagesGetChatUsers,
    VKQueriesTypesMessagesAddChatUser,
    VKQueriesTypesMessagesRemoveChatUser,
    VKQueriesTypesMessagesGetLongPollServer,    
	VKQueriesTypesMessagesGetUploadServer, 
	VKQueriesTypesMessagesAddAttachment
} VKQueriesTypes;


// User field
#define kUserFirstName @"first_name"
#define kUserLastName @"last_name"
#define kUserPhoto @"photo"
#define kUserUid @"uid"
#define kUserSex @"sex" // Возвращаемые значения: 1 - женский, 2 - мужской, 0 - без указания пола. 
#define kUserOnline @"online" // Возвращаемые значения: 0 - пользователь не в сети, 1 - пользователь в сети. 
#define kUserDbdate @"bdate" // Дата рождения, выдаётся в формате: "23.11.1981" или "21.9" (если год скрыт). Если дата рождения скрыта целиком, то при приёме данных в формате XML в узле <user> отсутствует тег bdate. 
#define kUserCity @"city" // Выдаётся id города, указанного у пользователя в разделе "Контакты". Название города по его id можно узнать при помощи метода getCities. Если город не указан, то при приёме данных в формате XML в узле <user> отсутствует тег city. 
#define kUserCountry @"country" // Выдаётся id страны, указанной у пользователя в разделе "Контакты". Название страны по её id можно узнать при помощи метода getCountries. Если страна не указана, то при приёме данных в формате XML в узле <user> отсутствует тег country. 
#define kUserPhoto @"photo" // Выдаётся url фотографии пользователя, имеющей ширину 50 пикселей.
#define kUserPhotoMedium @"photo_medium" // Выдаётся url фотографии пользователя, имеющей ширину 100 пикселей. 
#define kUserPhotoMediumRec @"photo_medium_rec" // Выдаётся url квадратной фотографии пользователя, имеющей ширину 100 пикселей. 
#define kUserPhotoBig @"photo_big" // Выдаётся url фотографии пользователя, имеющей ширину 200 пикселей. 
#define kUserPhotoRec @"photo_rec" // Выдаётся url квадратной фотографии пользователя, имеющей ширину 50 пикселей. 
#define kUserLists @"lists" //Список, содержащий id списков друзей, в которых состоит текущий друг пользователя. Метод получения id и названий списков: friends.getLists. Поле доступно только для метода friends.get. Если текущий друг не состоит ни в одном списке, то при приёме данных в формате XML в узле <user> отсутствует тег lists. 
#define kUserScreenName @"screen_name" // Возвращает короткий адрес страницы (возвращается только имя адреса, например andrew). Если пользователь не менял адрес своей страницы, возвращается 'id'+uid, например id35828305. 
#define kUserHasMobile @"has_mobile" // Показывает, известен ли номер мобильного телефона пользователя. Возвращаемые значения: 1 - известен, 0 - не известен. 
#define kUserRate @"rate" // Возвращает рейтинг пользователя. 
#define kUserContacts @"contacts" // Возвращает в поле mobile_phone мобильный телефон пользователя, а в поле home_phone домашний телефон пользователя, если эти данные указаны и не скрыты соотвествующими настройками приватности. 
#define kUserEducation @"education" // Возвращает код и название университета пользователя, а также факультет и год оконочания. 
#define kUserCanPost @"can_post" // Разрешено ли оставлять записи на стене у данного пользователя. 
#define kUserCanSeeAllPosts @"can_see_all_posts" // Разрешено ли текущему пользователю видеть записи других пользователей на стене данного пользователя. 
#define kUserCanWritePrivateMessage @"can_write_private_message" // Разрешено ли написание личных сообщений данному пользователю. 
#define kUserActivity @"activity" // Возвращает статус, расположенный в профиле, под именем пользователя
#define kUserLastSeen @"last_seen" // Возвращает объект, содержащий поле time, в котором содержится время последнего захода пользователя. 
#define kUserRelation @"relation" /* 
Возвращает семейное положение пользователя: 
1 - не женат/не замужем 
2 - есть друг/есть подруга 
3 - помолвлен/помолвлена 
4 - женат/замужем 
5 - всё сложно 
6 - в активном поиске 
7 - влюблён/влюблена 
*/
#define kUserNickname @"nickname" // Данное поле возвращается только в том случае, если получается не больше одного профиля. 
#define kUserExports @"exports" // В случае, если запрашивается текущий пользователь — возвращает объект exports содержаций настроенные пользователем сервисы для экспорта, например twitter и facebook.
#define kUserWallComments @"wall_comments" // Разрешено ли комментирование стены. Если комментирование стены отключено - то комментарии на стене не отображаются. 



//
//Message fields
#define kMessageMid @"mid" // ID сообщения. Не передаётся для пересланных сообщений.
#define kMessageUid @"uid" // автор сообщения
#define kMessageDate @"date" // дата отправки сообщения
#define kMessageReadState @"read_state" // статус прочтения сообщения (0 – не прочитано, 1 – прочитано) Не передаётся для пересланных сообщений.
#define kMessageOut @"out" // тип сообщения (0 – полученное сообщение, 1 – отправленное сообщение). Не передаётся для пересланных сообщений.
#define kMessageTitle @"title" // заголовок сообщения или беседы
#define kMessageBody @"body" // текст сообщения
#define kMessageAttachments @"attachments" // массив медиа-вложений (если есть)
#define kMessageFwdMessages @"fwd_messages" // массив пересланных сообщений (если есть)
#define kMessageChatId @"chat_id" // (только для групповых бесед) ID беседы
#define kMessageChatActive @"chat_active" // (только для групповых бесед) ID последних участников беседы, разделённых запятыми, но не более 6.
#define kMessageUsersCount @"users_count" // (только для групповых бесед) количество участников в беседе
#define kMessageAdminId @"admin_id" // (только для групповых бесед) ID создателя беседы
#define kMessageFromUid @"from_id" // (от кого пришло сообщение)


//
// Variables for responce ident
#define kExecuteMessageDialogs @"dialogs"
#define kExecuteMessageHistory @"history"
#define kExecuteMessageUsers @"users"
#define kExecuteMessageChatActiveUsers @"chatActiveUsers"
#define kExecuteMessageMessage @"message"
#define kExecuteMessageUser @"user"


//
// LongPoll responce var
#define kLongPollTs @"ts"
#define kLongPollServer @"server"
#define kLongPollKey @"key"
#define kLongPollUpdates @"updates"

#define uLongPollMessageDelete 0 //$message_id,0 -- удаление сообщения с указанным local_id
#define uLongPollMessageFlagsChange 1 //$message_id,$flags -- замена флагов сообщения (FLAGS:=$flags)
#define uLongPollMessageFlagsSet 2 //$message_id,$mask[,$user_id] -- установка флагов сообщения (FLAGS|=$mask)    
#define uLongPollMessageFlagsReset 3 //$message_id,$mask[,$user_id] -- сброс флагов сообщения (FLAGS&=~$mask)
#define uLongPollMessageAddPrivate 4 //$message_id,$flags,$from_id,$timestamp,$subject,$text,$attachments -- добавление нового сообщения
#define uLongPollFriendsBecomeOnline 8 //-$user_id,0 -- друг $user_id стал онлайн
#define uLongPollFriendsBecomeOffline 9 //-$user_id,$flags -- друг $user_id стал оффлайн ($flags равен 0, если пользователь покинул сайт (например, нажал выход) и 1, если оффлайн по таймауту (например, статус away))
#define uLongPollDialogsChanges 51 //$chat_id,$self -- один из параметров (состав, тема) беседы $chat_id были изменены. $self - были ли изменения вызываны самим пользователем
#define uLongPollDialogsTyping 61 //$user_id,$flags -- пользователь $user_id начал набирать текст в диалоге. событие должно приходить раз в ~5 секунд при постоянном наборе текста. $flags = 1
#define uLongPollMessagesTyping 62 //$user_id,$chat_id -- пользователь $user_id начал набирать текст в беседе $chat_id.


#define uLPNotificationFriendsBecomeOnline @"FriendsBecomeOnline"
#define uLPNotificationFriendsBecomeOffline @"FriendsBecomeOffline"
#define uLPNotificationDialogsChanges @"DialogsChanges"
#define uLPNotificationMessagesTyping @"MessagesTyping"
#define uLPNotificationDialogsTyping @"DialogsTyping"
#define uLPNotificationMessageAddPrivate @"MessageAddPrivate"
#define uLPNotificationMessageFlagsReset @"MessageFlagsReset"
#define uLPNotificationMessageDelete @"MessageDelete"
#define uLPNotificationMessageFlagsSet @"MessageFlagsSet"
#define uLPNotificationMessageFlagsChange @"MessageFlagsChange"

// Long pool Flags
#define UNREAD 1
#define	OUTBOX 2
#define REPLIED 4
#define IMPORTANT 8
#define CHAT 16
#define FRIENDS 32
#define SPAM 64
#define DELETED 128
#define FIXED 256
#define MEDIA 512