#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_SIZE 31

typedef struct Node Node;

struct Node {

    // A node represents a single symbol

    const char* key;
    void* value;

    int scope, line_number;
    Node* next;
};

struct SymTable
{
   size_t size;
   struct Node* First;
};

typedef struct SymTable SymTable;

// Create a new symbol table
SymTable* create() {
    SymTable* newTable = malloc(sizeof(struct SymTable));

    if (newTable == NULL)
        return NULL;

    newTable->First = NULL;
    newTable->size = 0;
    return newTable;
}

// Delete the whole symbol table
void removeTable(SymTable* Table) {
    struct Node *Current = Table->First;
    struct Node *next;

    if (Table == NULL) return;

    for ( ; Current != NULL; Current = next)
    {
        next= Current->next;
        free((char*)Current->key);
        free(Current);
    }

    free(Table);
}

// Delete a single symbol 
void* removeSymbol(SymTable* Table, const char *Key){
   
    assert(Table != NULL);
    assert(Key != NULL);

    // traverse until found 
    struct Node* current = Table->First;
    struct Node* prev = NULL;
    int found = 0;
   
    while (current != NULL){
        if (strcmp(Key, current->key) == 0) {
            found = 1;
            break;
        }
        prev = current;
        current = current->next;
    }

    if (!found || current == NULL)
        return NULL;
   
    // first node is node with key 
    if (prev == NULL)
        Table->First = current->next;

    // otherwise
    else prev->next = current->next;
   
    void* returnValue = current->value;
    free((char*) current->key);
    free(current);
    Table->size--;
    return returnValue;
}

// Check is table contains a key
int lookup(SymTable* Table, const char* Key) {

    assert(Table != NULL);
    assert(Key != NULL);

    struct Node* current = Table->First;
    struct Node* prev = NULL;
   
    while (current != NULL){
        if (strcmp(Key, current->key) == 0) {
            return 1;
        }
        prev = current;
        current = current->next;
    }

    return 0;
}

// Insert new symbol
int insert(SymTable* Table, const char *Key, void *Value, int Scope, int lineNo){
   
    // Check if table has been intialized
    assert(Table != NULL);

    // The symbol table shouldn't have an infinite number f symbols
    // so there is a restriction on its size
    assert(Table->size != MAX_SIZE);
    assert(Key != NULL);

    // check if Key already in the SymTable 
    if (lookup(Table, Key)) 
        return -1;
   
    struct Node *newNode = malloc(sizeof(struct Node));
    if (newNode == NULL)
        return -2;
   
    // create a new node
    newNode->key = (const char*) malloc(strlen(Key) + 1);
    strcpy((char*)newNode->key, Key);
    newNode->value = (void*) Value;
    newNode->scope = Scope;
    newNode->line_number = lineNo;

    // append new Node to beginning of the list 
    newNode->next = Table->First;
    Table->First = newNode;
    Table->size++;
    return 1;
}

// Return a symbol's value
void* get(SymTable* Table, const char* Key) {

    assert(Table != NULL);
    assert(Key != NULL);

    struct Node* current = Table->First;
    struct Node* prev = NULL;
   
    while (current != NULL){
        if (strcmp(Key, current->key) == 0) {
            return current->value;
        }
        prev = current;
        current = current->next;
    }

    return NULL;
}

// Modify a symbol's value 
void* modify(SymTable* Table, const char* Key, void *newValue) {

    assert(Table != NULL);
    assert(Key != NULL);

    struct Node* current = Table->First;
    struct Node* prev = NULL;
   
    while (current != NULL){
        if (strcmp(Key, current->key) == 0) {
            void* returnValue = current->value;
            current->value = newValue;
            return returnValue;
        }
        prev = current;
        current = current->next;
    }

    return NULL;
}

// Display the whole table
void display(SymTable* Table) {
    struct Node *Current = Table->First;
    struct Node *next;

    if (Table == NULL) 
        printf("Empty Table");
        return;

    for ( ; Current != NULL; Current = next)
    {
        next = Current->next;
        printf("%c %d %d",Current->key, Current->scope, Current->scope);
    }
}