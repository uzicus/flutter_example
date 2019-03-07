package com.example.flutterapp

import android.content.Context
import android.database.Cursor
import android.os.AsyncTask
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import android.provider.ContactsContract
import java.lang.ref.WeakReference

class MainActivity : FlutterActivity() {

    companion object {
        private const val CHANNEL_CONTACTS = "contacts"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL_CONTACTS)
            .setMethodCallHandler { methodCall, result ->
                if (methodCall.method == "getContacts") {
                    GetContactsTask(
                        WeakReference(this),
                        onContactsResult = result::success,
                        onContactsError = { result.error(it.toString(), null, null) }
                    ).execute()
                }
            }
    }

    class GetContactsTask(
        private val contextReference: WeakReference<Context>,
        private val onContactsResult: ((List<Map<String, String>>) -> Unit),
        private val onContactsError: ((Exception) -> Unit)
    ) : AsyncTask<Unit, Unit, List<Map<String, String>>>() {

        private val context
            get() = contextReference.get()

        private inline fun <reified T> Cursor.getByColumnName(columnName: String): T? {
            val columnIndex = getColumnIndex(columnName)
            return when (T::class) {
                Int::class -> getInt(columnIndex) as? T
                String::class -> getString(columnIndex) as? T
                else -> null
            }
        }

        override fun doInBackground(vararg params: Unit?): List<Map<String, String>> {
            try {
                val usersCursor = context?.contentResolver?.query(
                    ContactsContract.Contacts.CONTENT_URI,
                    arrayOf(
                        ContactsContract.Contacts._ID,
                        ContactsContract.Contacts.DISPLAY_NAME_PRIMARY
                    ),
                    "${ContactsContract.Contacts.HAS_PHONE_NUMBER} = '1'",
                    null,
                    "${ContactsContract.Contacts.DISPLAY_NAME} COLLATE LOCALIZED ASC"
                )

                val contacts = mutableListOf<Map<String, String>>()

                while (usersCursor != null && usersCursor.moveToNext()) {
                    val contactId = usersCursor.getByColumnName<Int>(ContactsContract.Contacts._ID)
                    val displayName = usersCursor.getByColumnName<String>(ContactsContract.Contacts.DISPLAY_NAME)

                    val contactNumbersCursor = context?.contentResolver?.query(
                        ContactsContract.CommonDataKinds.Phone.CONTENT_URI,
                        null,
                         "${ContactsContract.CommonDataKinds.Phone.CONTACT_ID} = $contactId",
                        null,
                        null
                    )

                    var mobileNumber: String? = null
                    while (contactNumbersCursor != null && contactNumbersCursor.moveToNext()) {
                        val type = contactNumbersCursor.getByColumnName<Int>(ContactsContract.CommonDataKinds.Phone.TYPE)

                        // Ignore that number
                        if (type == ContactsContract.CommonDataKinds.Phone.TYPE_MOBILE) {
                            mobileNumber = contactNumbersCursor.getByColumnName<String>(ContactsContract.CommonDataKinds.Phone.NUMBER)
                            break
                        }
                    }
                    contactNumbersCursor?.close()

                    contacts.add(
                        mapOf(
                            "NAME" to displayName.orEmpty(),
                            "MOBILE" to mobileNumber.orEmpty()
                        )
                    )
                }

                usersCursor?.close()

                return contacts

            } catch (exception: Exception) {
                onContactsError.invoke(exception)
            }

            return emptyList()
        }

        override fun onPostExecute(result: List<Map<String, String>>) {
           onContactsResult.invoke(result)
        }
    }

}
