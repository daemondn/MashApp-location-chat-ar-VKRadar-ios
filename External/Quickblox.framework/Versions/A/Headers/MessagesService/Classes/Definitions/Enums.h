/*
 *  Enums.h
 *  MessagesService
 *

 *  Copyright 2011 QuickBlox team. All rights reserved.
 *
 */

// Event types
typedef enum QBMEventType{
	QBMEventTypeOneShot,
    QBMEventTypeFixedDate,
    QBMEventTypePeriodDate,
    QBMEventTypeMultiShot
} QBMEventType;

// Event notification types
typedef enum QBMEventNotificationType{
	QBMEventNotificationTypePush,
    QBMEventNotificationTypeEmail,
    QBMEventNotificationTypeRequest,
    QBMEventNotificationTypePull
} QBMEventNotificationType;

// Notification channels
typedef enum QBMNotificatioChannel{
    QBMNotificatioChannelEmail,
    QBMNotificatioChannelAPNS,
    QBMNotificatioChannelC2DM,
    QBMNotificatioChannelMPNS,
    QBMNotificatioChannelPull,
    QBMNotificatioChannelHttpRequest
} QBMNotificatioChannel;