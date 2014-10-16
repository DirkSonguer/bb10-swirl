/****************************************************************************
** Meta object code from reading C++ file 'CommunicationInvokes.hpp'
**
** Created by: The Qt Meta Object Compiler version 63 (Qt 4.8.6)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../src/CommunicationInvokes.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'CommunicationInvokes.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.6. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_CommunicationInvokes[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       5,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // methods: signature, parameters, type, tag, flags
      34,   22,   21,   21, 0x02,
      82,   67,   21,   21, 0x02,
     113,  108,   21,   21, 0x02,
     151,  141,   21,   21, 0x02,
     190,  179,   21,   21, 0x02,

       0        // eod
};

static const char qt_meta_stringdata_CommunicationInvokes[] = {
    "CommunicationInvokes\0\0sendTo,body\0"
    "sendTextMessage(QString,QString)\0"
    "sendTo,subject\0sendMail(QString,QString)\0"
    "body\0sendTwitterMessage(QString)\0"
    "twitterId\0openTwitterProfile(QString)\0"
    "facebookId\0openFacebookProfile(QString)\0"
};

void CommunicationInvokes::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Q_ASSERT(staticMetaObject.cast(_o));
        CommunicationInvokes *_t = static_cast<CommunicationInvokes *>(_o);
        switch (_id) {
        case 0: _t->sendTextMessage((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 1: _t->sendMail((*reinterpret_cast< const QString(*)>(_a[1])),(*reinterpret_cast< const QString(*)>(_a[2]))); break;
        case 2: _t->sendTwitterMessage((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 3: _t->openTwitterProfile((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 4: _t->openFacebookProfile((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        default: ;
        }
    }
}

const QMetaObjectExtraData CommunicationInvokes::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject CommunicationInvokes::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_CommunicationInvokes,
      qt_meta_data_CommunicationInvokes, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &CommunicationInvokes::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *CommunicationInvokes::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *CommunicationInvokes::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_CommunicationInvokes))
        return static_cast<void*>(const_cast< CommunicationInvokes*>(this));
    return QObject::qt_metacast(_clname);
}

int CommunicationInvokes::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 5)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 5;
    }
    return _id;
}
QT_END_MOC_NAMESPACE
